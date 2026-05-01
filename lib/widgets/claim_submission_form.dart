import 'package:flutter/material.dart';

import '../app_state.dart';

class ClaimSubmissionForm extends StatefulWidget {
  const ClaimSubmissionForm({super.key, required this.appState, required this.onSubmitted});

  final AppState appState;
  final VoidCallback onSubmitted;

  @override
  State<ClaimSubmissionForm> createState() => _ClaimSubmissionFormState();
}

class _ClaimSubmissionFormState extends State<ClaimSubmissionForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _documentController = TextEditingController();
  String? _uploadedDocumentUrl;
  bool _documentUploaded = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (!widget.appState.isSessionValid) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired. Please login again.')),
        );
        Navigator.pushReplacementNamed(context, '/');
      });
    }
  }

  void _uploadDocument() {
    final documentName = _documentController.text.trim();
    if (documentName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a document name before uploading.')),
      );
      return;
    }

    final documentUrl = widget.appState.uploadDocument(documentName);
    setState(() {
      _uploadedDocumentUrl = documentUrl;
      _documentUploaded = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Document uploaded: $documentUrl')),
    );
  }

  Future<void> _submitClaim() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_documentUploaded || _uploadedDocumentUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload the supporting document before submitting.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final description = _descriptionController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final documentName = _documentController.text.trim();

    try {
      final claim = widget.appState.submitNewClaim(
        description: description,
        amount: amount,
        documentName: documentName,
        documentUrl: _uploadedDocumentUrl!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Claim ${claim.id} submitted successfully.')),
      );

      widget.onSubmitted();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to submit claim: $error')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Submit your claim', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              if (_uploadedDocumentUrl != null)
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Document uploaded to:\n$_uploadedDocumentUrl'),
                  ),
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Claim description'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter a claim description' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount (ZAR)'),
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter the claim amount';
                  }
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _documentController,
                decoration: const InputDecoration(labelText: 'Supporting document name'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter a document name' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadDocument,
                child: const Text('Upload document'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitClaim,
                child: _isSubmitting ? const CircularProgressIndicator() : const Text('Submit claim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
