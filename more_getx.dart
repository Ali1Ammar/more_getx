typedef GetControllerBuilder<T> = Widget Function(T controller);

class GetBuilderC<T extends SimpleGetxController> extends StatefulWidget {
  final GetControllerBuilder<T> builder;
  final T controller;
  final void Function(State state) initState, dispose, didChangeDependencies;
  final void Function(GetBuilderC oldWidget, State state) didUpdateWidget;
  const GetBuilderC({
    Key key,
    @required this.builder,
    this.initState,
    this.dispose,
    this.didChangeDependencies,
    this.didUpdateWidget,
    this.controller,
  })  : assert(builder != null),
        super(key: key);

  @override
  _GetBuilderState<T> createState() => _GetBuilderState<T>();
}

class _GetBuilderState<T extends SimpleGetxController>
    extends State<GetBuilderC<T>> with GetStateUpdaterMixin {
  T controller;

  VoidCallback remove;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    if (widget.initState != null) widget.initState(this);

    _subscribeToController();
  }

  void _subscribeToController() {
    remove?.call();
    remove = controller?.addListener(getUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.dispose != null) widget.dispose(this);
    remove?.call();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.didChangeDependencies != null) {
      widget.didChangeDependencies(this);
    }
  }

  @override
  void didUpdateWidget(GetBuilderC oldWidget) {
    super.didUpdateWidget(oldWidget as GetBuilderC<T>);
    if (widget.didUpdateWidget != null) widget.didUpdateWidget(oldWidget, this);
  }

  @override
  Widget build(BuildContext context) => widget.builder(controller);
}

class SimpleGetxController {
  final _updaters = HashSet<GetStateUpdate>();
  void update() {
    for (final updater in _updaters) {
      updater();
    }
  }

  VoidCallback addListener(GetStateUpdate listener) {
    _updaters.add(listener);
    return () => _updaters.remove(listener);
  }
}

class SimpleValue<T> extends SimpleGetxController {
  SimpleValue([this._value]);

  T _value;

  T get value {
    TaskManager.instance.notify(_updaters);
    return _value;
  }

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    update();
  }
}

extension GetNotifierExt<T> on T {
  SimpleValue<T> get notifier => SimpleValue<T>(this);
}
