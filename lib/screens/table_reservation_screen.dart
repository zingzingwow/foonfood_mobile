import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';

class TableReservationScreen extends StatefulWidget {
  const TableReservationScreen({super.key});

  @override
  State<TableReservationScreen> createState() => _TableReservationScreenState();
}

class _TableReservationScreenState extends State<TableReservationScreen> {
  int _guests = 2;
  DateTime _date = DateTime.now();
  TimeOfDay _time = const TimeOfDay(hour: 19, minute: 0);
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt bàn'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Số khách', style: AppTheme.body.copyWith(fontWeight: FontWeight.w600)),
            Row(
              children: [
                IconButton(onPressed: () => setState(() => _guests = (_guests - 1).clamp(1, 20)), icon: const Icon(Icons.remove_circle_outline)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('$_guests', style: AppTheme.heading3)),
                IconButton(onPressed: () => setState(() => _guests = (_guests + 1).clamp(1, 20)), icon: const Icon(Icons.add_circle, color: AppTheme.primaryOrange)),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Ngày'),
              subtitle: Text('${_date.day}/${_date.month}/${_date.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                if (d != null) setState(() => _date = d);
              },
            ),
            ListTile(
              title: const Text('Giờ'),
              subtitle: Text(_time.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final t = await showTimePicker(context: context, initialTime: _time);
                if (t != null) setState(() => _time = t);
              },
            ),
            const SizedBox(height: 16),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Số điện thoại *', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Xác nhận đặt bàn',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã đặt bàn thành công!')),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
