import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

void main() => runApp(const QuickPanelApp());

class QuickPanelApp extends StatelessWidget {
  const QuickPanelApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: '万能快捷面板', debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true, brightness: Brightness.light),
    darkTheme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true, brightness: Brightness.dark),
    home: const PanelHomePage(),
  );
}

class QuickAction {
  String id, name, icon, type, value;
  int colorValue;
  QuickAction({required this.id, required this.name, required this.icon, required this.type, required this.value, this.colorValue = 0xFF3F51B5});
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'icon': icon, 'type': type, 'value': value, 'color': colorValue};
  factory QuickAction.fromJson(Map<String, dynamic> j) => QuickAction(id: j['id'], name: j['name'], icon: j['icon'], type: j['type'], value: j['value'], colorValue: j['color'] ?? 0xFF3F51B5);
}

class PanelHomePage extends StatefulWidget {
  const PanelHomePage({super.key});
  @override
  State<PanelHomePage> createState() => _PanelHomePageState();
}

class _PanelHomePageState extends State<PanelHomePage> {
  List<QuickAction> _actions = [];
  String _filter = 'all';
  final _types = ['all', 'app', 'url', 'text', 'cmd'];
  final _typeLabels = {'all': '全部', 'app': '应用', 'url': '网址', 'text': '文本', 'cmd': '命令'};
  final _icons = ['🌐', '📁', '🔢', '💻', '📷', '📋', '⚙️', '🔒', '📧', '🎵', '📝', '🎮', '🛒', '📱', '💡', '🔥', '⚡', '🚀', '🎯', '📊'];
  final _colors = [0xFF3F51B5, 0xFF2196F3, 0xFF009688, 0xFF4CAF50, 0xFFFF9800, 0xFFF44336, 0xFF9C27B0, 0xFFE91E63, 0xFF795548, 0xFF607D8B, 0xFF00BCD4, 0xFFFF5722];

  Future<File> get _file async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/quickpanel_actions.json');
  }

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final f = await _file;
      if (await f.exists()) {
        final d = await f.readAsString();
        setState(() => _actions = (json.decode(d) as List).map((e) => QuickAction.fromJson(e)).toList());
      } else {
        _actions = [
          QuickAction(id: '1', name: '浏览器', icon: '🌐', type: 'url', value: 'https://google.com', colorValue: 0xFF2196F3),
          QuickAction(id: '2', name: '计算器', icon: '🔢', type: 'app', value: 'calculator', colorValue: 0xFF4CAF50),
          QuickAction(id: '3', name: '终端', icon: '💻', type: 'cmd', value: 'terminal', colorValue: 0xFF607D8B),
          QuickAction(id: '4', name: '截图', icon: '📷', type: 'cmd', value: 'screenshot', colorValue: 0xFFE91E63),
          QuickAction(id: '5', name: '设置', icon: '⚙️', type: 'app', value: 'settings', colorValue: 0xFF795548),
          QuickAction(id: '6', name: '锁屏', icon: '🔒', type: 'cmd', value: 'lock', colorValue: 0xFF3F51B5),
        ];
        _save();
      }
    } catch (_) {}
  }

  Future<void> _save() async {
    final f = await _file;
    await f.writeAsString(json.encode(_actions.map((e) => e.toJson()).toList()));
  }

  List<QuickAction> get _filtered => _filter == 'all' ? _actions : _actions.where((a) => a.type == _filter).toList();

  void _run(QuickAction a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('执行: ${a.name}'), duration: const Duration(seconds: 1), behavior: SnackBarBehavior.floating));
  }

  void _add() => _showEditor(null);
  void _edit(int i) => _showEditor(_filtered[i]);

  void _showEditor(QuickAction? existing) {
    final nameC = TextEditingController(text: existing?.name ?? '');
    final valueC = TextEditingController(text: existing?.value ?? '');
    String type = existing?.type ?? 'app';
    String icon = existing?.icon ?? '🌐';
    int color = existing?.colorValue ?? 0xFF3F51B5;
    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => AlertDialog(
      title: Text(existing == null ? '添加快捷操作' : '编辑快捷操作'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameC, decoration: const InputDecoration(labelText: '名称', border: OutlineInputBorder(), prefixIcon: Icon(Icons.label))),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(value: type, decoration: const InputDecoration(labelText: '类型', border: OutlineInputBorder()), items: _typeLabels.entries.where((e) => e.key != 'all').map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(), onChanged: (v) => setS(() => type = v!)),
        const SizedBox(height: 12),
        TextField(controller: valueC, decoration: InputDecoration(labelText: type == 'url' ? '网址' : type == 'app' ? '应用名' : type == 'text' ? '文本内容' : '命令', border: const OutlineInputBorder()), maxLines: type == 'text' ? 3 : 1),
        const SizedBox(height: 12),
        const Align(alignment: Alignment.centerLeft, child: Text('图标', style: TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, children: _icons.map((ic) => GestureDetector(
          onTap: () => setS(() => icon = ic),
          child: Container(width: 40, height: 40, decoration: BoxDecoration(color: icon == ic ? Color(color).withValues(alpha: 0.2) : Colors.transparent, border: Border.all(color: icon == ic ? Color(color) : Colors.grey.shade300, width: icon == ic ? 2 : 1), borderRadius: BorderRadius.circular(8)), child: Center(child: Text(ic, style: const TextStyle(fontSize: 22)))),
        )).toList()),
        const SizedBox(height: 12),
        const Align(alignment: Alignment.centerLeft, child: Text('颜色', style: TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, children: _colors.map((c) => GestureDetector(
          onTap: () => setS(() => color = c),
          child: Container(width: 32, height: 32, decoration: BoxDecoration(color: Color(c), shape: BoxShape.circle, border: Border.all(color: color == c ? Colors.white : Colors.transparent, width: 3), boxShadow: color == c ? [BoxShadow(color: Color(c).withValues(alpha: 0.5), blurRadius: 6)] : null), child: color == c ? const Icon(Icons.check, color: Colors.white, size: 18) : null),
        )).toList()),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
        FilledButton(onPressed: () {
          if (nameC.text.isEmpty || valueC.text.isEmpty) return;
          final a = QuickAction(id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(), name: nameC.text, icon: icon, type: type, value: valueC.text, colorValue: color);
          setState(() { if (existing != null) { final i = _actions.indexWhere((x) => x.id == existing.id); if (i >= 0) _actions[i] = a; } else { _actions.add(a); } });
          _save(); Navigator.pop(ctx);
        }, child: const Text('保存')),
      ],
    )));
  }

  void _delete(QuickAction a) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('确认删除'), content: Text('删除「${a.name}」？'),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')), FilledButton(onPressed: () { setState(() => _actions.removeWhere((x) => x.id == a.id)); _save(); Navigator.pop(ctx); }, child: const Text('删除'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cols = MediaQuery.of(context).size.width > 600 ? 4 : 3;
    return Scaffold(
      appBar: AppBar(title: const Text('⚡ 万能快捷面板'), centerTitle: true, actions: [IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: _add, tooltip: '添加')]),
      body: Column(children: [
        SizedBox(height: 48, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), children: _types.map((t) => Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6), child: FilterChip(label: Text(_typeLabels[t]!), selected: _filter == t, onSelected: (_) => setState(() => _filter = t)))).toList())),
        const Divider(height: 1),
        Expanded(child: _filtered.isEmpty ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.touch_app, size: 64, color: Colors.grey), SizedBox(height: 16), Text('暂无快捷操作', style: TextStyle(color: Colors.grey, fontSize: 16))])) : GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1), itemCount: _filtered.length, itemBuilder: (ctx, i) {
          final a = _filtered[i];
          return GestureDetector(
            onTap: () => _run(a),
            onLongPress: () => showModalBottomSheet(context: context, builder: (ctx) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(leading: const Icon(Icons.play_arrow), title: const Text('执行'), onTap: () { Navigator.pop(ctx); _run(a); }),
              ListTile(leading: const Icon(Icons.edit), title: const Text('编辑'), onTap: () { Navigator.pop(ctx); _edit(i); }),
              ListTile(leading: const Icon(Icons.delete, color: Colors.red), title: const Text('删除', style: TextStyle(color: Colors.red)), onTap: () { Navigator.pop(ctx); _delete(a); }),
            ]))),
            child: Card(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(a.colorValue).withValues(alpha: 0.7), Color(a.colorValue)])), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(a.icon, style: const TextStyle(fontSize: 36)), const SizedBox(height: 8), Text(a.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)]))),
          );
        })),
      ]),
    );
  }
}
