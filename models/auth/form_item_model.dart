class FormItem<T> {
  const FormItem(this.value, {this.error = ''});

  final T value;
  final String? error;
}
