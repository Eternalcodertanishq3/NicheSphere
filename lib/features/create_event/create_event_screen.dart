import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/success_overlay.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'Gaming';
  DateTime? _selectedDate;

  bool _showSuccessOverlay = false;

  void _onPublish() {
    if (_formKey.currentState!.validate()) {
      setState(() => _showSuccessOverlay = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundPastel,
          appBar: AppBar(
            title: const Text('Create Event', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => context.go('/home'),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bring your community together',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildLabel('Event Title'),
                  _buildTextField(_titleController, 'Give it a catchy name', Icons.title_rounded),
                  
                  const SizedBox(height: 24),
                  _buildLabel('Description'),
                  _buildTextField(_descController, 'Tell people what to expect', Icons.description_rounded, maxLines: 4),
                  
                  const SizedBox(height: 24),
                  _buildLabel('Category'),
                  _buildCategorySelector(),
                  
                  const SizedBox(height: 24),
                  _buildLabel('Date & Time'),
                  _buildDatePicker(),
                  
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onPublish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryPastel,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Publish Event', 
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        if (_showSuccessOverlay)
          SuccessOverlay(
            showConfettiAfter: true,
            onCompleted: () {
              setState(() => _showSuccessOverlay = false);
              context.go('/home');
            },
          ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
    return GlassCard(
      opacity: 0.5,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.black38),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = ['Gaming', 'Wellness', 'Art', 'Music', 'Tech'];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: Chip(
                label: Text(cat),
                backgroundColor: isSelected ? AppColors.bubbleBlue : Colors.white.withOpacity(0.5),
                side: BorderSide.none,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: GlassCard(
        opacity: 0.5,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, color: Colors.black38),
            const SizedBox(width: 12),
            Text(
              _selectedDate == null 
                  ? 'Select a date' 
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              style: TextStyle(
                color: _selectedDate == null ? Colors.black38 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
