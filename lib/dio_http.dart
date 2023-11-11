import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

const String baseUrl = 'https://jsonplaceholder.typicode.com/';

final options = BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 3),
);

Dio dioInstance() {
  final dio = Dio(
    options,
  );
  const String fingerprint = '51e844a47d7be38d19f1f521d680e3d474988f2118b3e6949d208eece504e576';
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      // Don't trust any certificate just because their root cert is trusted.
      final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
      // You can test the intermediate / root cert here. We just ignore it.
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    },
    validateCertificate: (cert, host, port) {
      // Check that the cert fingerprint matches the one we expect.
      // We definitely require _some_ certificate.
      if (cert == null) {
        return false;
      }
      // Validate it any way you want. Here we only check that
      // the fingerprint matches the OpenSSL SHA256.
      log('SHA256: ${sha256.convert(cert.der).toString()}');
      return fingerprint == sha256.convert(cert.der).toString();
    },
  );

  return dio;
}
