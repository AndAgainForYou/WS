class ValidateApiUrl {
  const ValidateApiUrl();

  String? call(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      return 'URL cannot be empty';
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return 'Please enter a valid URL';
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return 'URL must start with http:// or https://';
    }
    return null;
  }
}
