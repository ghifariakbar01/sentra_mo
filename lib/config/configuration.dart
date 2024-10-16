library configuration;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../style/style.dart';
import '../utils/http_overrides.dart';
import '../utils/logging.dart';

part 'src/build_config.dart';
part 'src/env.dart';
