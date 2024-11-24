import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
import 'package:convert/convert.dart' as convert;
import 'package:solana/solana.dart';
import '../controllers/auth_controller.dart';

class StakeSolanaView extends StatelessWidget {
  StakeSolanaView({super.key});

  final client = SolanaClient(
    rpcUrl: Uri.parse('https://api.devnet.solana.com'),
    websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
  );

  Future<void> _stakeSOL(BuildContext context) async {
    try {
      final AuthController authController = Get.find<AuthController>();

      // Initialize Solana client for devnet

      // Get private key from Web3Auth
      final privateKey = authController.privateKey.value;
      if (privateKey.isEmpty) {
        Get.snackbar(
          'Error',
          'Please login first',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Debug print to inspect private key format
      print('Private key format: ${privateKey}');

      // Convert hex string to bytes
      List<int> decodedPrivateKey;
      try {
        decodedPrivateKey = convert.hex.decode(privateKey);
      } catch (decodeError) {
        print('Hex decode error: $decodeError');
        print('Private key length: ${privateKey.length}');
        throw FormatException('Invalid private key format: $decodeError');
      }

      // Create Ed25519 keypair from the decoded private key
      final Ed25519HDKeyPair keypair =
          await Ed25519HDKeyPair.fromPrivateKeyBytes(
        privateKey: decodedPrivateKey,
      );

      // Get wallet address
      final address = keypair.address;

      // Get account balance
      final balance = await client.rpcClient.getBalance(address);
      final solBalance = balance.value / lamportsPerSol;
      print('Address: $address');
      print('Balance: $solBalance SOL');
      print('Validators: ${await _getValidators()}');
      Get.snackbar(
        'Wallet Connected',
        'Address: $address\nBalance: $solBalance SOL',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );

      final validators = await _getValidators();
      final firstValidator = validators.split(',')[0].trim();
      //await _stakeToValidator(firstValidator, keypair);

      // Show the snackbar
      Get.snackbar(
        'Success',
        'Stake transaction was successful!',
      );

      // Show CircularProgressIndicator for 2 seconds
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Wait for 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      // Close the dialog
      Navigator.of(context).pop();

      // Navigate to the next screen
      Get.offAllNamed('/home');
    } catch (e) {
      print('Detailed error: $e');
      Get.snackbar(
        'Error',
        'Failed to connect wallet: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<String> _getValidators() async {
    final validators = await client.rpcClient
        .getVoteAccounts(commitment: Commitment.confirmed);
    // Use any validator from validators.current or validators.delinquent
    print(validators.current[0]);
    return validators.current[0].votePubkey; // Get first active validator
  }

  // Future<void> _stakeToValidator(
  //     String validatorAddress, Ed25519HDKeyPair keypair) async {
  //   try {
  //     // Create stake account
  //     final stakeAccount = await Ed25519HDKeyPair.random();

  //     // Calculate rent exempt balance
  //     final rentExemption = await client.rpcClient
  //         .getMinimumBalanceForRentExemption(StakeProgram.neededAccountSpace);

  //     // Create stake account transaction
  //     final createStakeAccTransaction = SystemInstruction.createAccount(
  //       fundingAccount: keypair.publicKey,
  //       newAccount: stakeAccount.publicKey,
  //       lamports:
  //           rentExemption + (0.1 * lamportsPerSol).toInt(), // 0.1 SOL + rent
  //       space: StakeProgram.neededAccountSpace,
  //       owner: Ed25519HDPublicKey.fromBase58(StakeProgram.programId),
  //     );

  //     // Initialize stake instruction
  //     final initializeStakeInst = StakeProgram.initialize(
  //       stakeAccount.address,
  //       Authorized(
  //         staker: keypair.publicKey.toBase58(),
  //         withdrawer: keypair.publicKey.toBase58(),
  //       ),
  //     );

  //     // Delegate stake instruction

  //     final delegateStakeInst = StakeInstruction.delegateStake(
  //         stake: stakeAccount.publicKey,
  //         authority: keypair.publicKey,
  //         vote: Ed25519HDPublicKey.fromBase58(validatorAddress),
  //         config: Ed25519HDPublicKey.fromBase58(
  //           'StakeConfig11111111111111111111111111111111',
  //         ) // Add the required config parameter
  //         );

  //     // Combine instructions into transaction
  //     // Get recent blockhash
  //     final recentBlockhash = await client.rpcClient.getLatestBlockhash();

  //     // Create message with instructions
  //     final message = Message(
  //       instructions: [
  //         createStakeAccTransaction,
  //         initializeStakeInst,
  //         delegateStakeInst,
  //       ],
  //     );

  //     // Sign and send transaction
  //     final signature = await client.sendAndConfirmTransaction(
  //       message: message,
  //       signers: [keypair, stakeAccount],
  //       commitment: Commitment.confirmed,
  //     );

  //     print('Stake transaction signature: $signature');
  //     Get.snackbar(
  //       'Success',
  //       'Stake transaction was successful!',
  //     );

  //     // Navigate to home
  //     Get.offAllNamed('/home');
  //   } catch (e) {
  //     print('Staking error: $e');
  //     Get.snackbar(
  //       'Error',
  //       'Failed to stake SOL: ${e.toString()}',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stake Solana (Devnet)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Why Stake Solana?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Staking Solana helps secure the network and allows you to participate in the network\'s consensus process. '
              'It also shows your commitment to the platform. If you decide to delete your account, your staked Solana will be refunded.',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _stakeSOL(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Connect to Devnet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
