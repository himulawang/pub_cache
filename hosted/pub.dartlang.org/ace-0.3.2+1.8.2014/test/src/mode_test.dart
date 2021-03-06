@TestGroup(description: 'Mode')
library ace.test.mode;

import 'package:ace/ace.dart';
import 'package:ace/proxy.dart';
import 'package:bench/bench.dart';
import 'package:unittest/unittest.dart';
import '_.dart';

const _ACE_MODE_PATH = 'ace/mode/';

@Setup
setup() {
  implementation = ACE_PROXY_IMPLEMENTATION;
}

// TODO(rms): https://github.com/rmsmith/ace.dart/issues/31
const _MODE_ID_BUGS = const [ Mode.APACHE_CONF, Mode.DJANGO, Mode.GLSL, 
                              Mode.LIVESCRIPT, Mode.LUAPAGE, Mode.LUCENE, 
                              Mode.MEL, Mode.PROPERTIES ];

@Test()
void testCreateModeNamed() {
  final verifyMode = (String modeName) {
    final mode = new Mode.named(modeName);
    mode.onLoad.then(expectAsync1((_) {
      expect(mode.isLoaded, isTrue);
      final session = createEditSession(sampleText, mode);
      expect(session, isNotNull); 
      if (!_MODE_ID_BUGS.contains(mode.name)) {
        expect(session.mode.name, equals(mode.name));
        expect(session.mode.path, equals(mode.path));
      }
    }));
    expect(mode, isNotNull);
    expect(mode.name, modeName);
    expect(mode.path, '${_ACE_MODE_PATH}$modeName');
  };
  Mode.MODES.forEach((String modeName) => verifyMode(modeName));
}

@Test()
void testCreateModeForFile() {
  final verifyMode = (String filePath, String modeName) {
    final mode = new Mode.forFile(filePath)
    ..onLoad.then(expectAsync1(noop1));
    expect(mode, isNotNull);
    expect(mode.name, modeName);
    expect(mode.path, '${_ACE_MODE_PATH}$modeName');
  };
  verifyMode('some/script.bat',     Mode.BATCHFILE);
  verifyMode('vm/allocator.c',      Mode.C_CPP);
  verifyMode('vm/allocator.cc',     Mode.C_CPP);
  verifyMode('vm/allocator.cpp',    Mode.C_CPP);
  verifyMode('vm/allocator.h',      Mode.C_CPP);
  verifyMode('strong.coffee',       Mode.COFFEE);
  verifyMode('vm/gc.cs',            Mode.CSHARP);
  verifyMode('twit/boot.css',       Mode.CSS);
  verifyMode('ftw.dart',            Mode.DART);
  verifyMode('ready/set.go',        Mode.GOLANG);
  verifyMode('ro/bot.hx',           Mode.HAXE);
  verifyMode('browser.html',        Mode.HTML);
  verifyMode('safe.hs',             Mode.HASKELL);
  verifyMode('midp/midlet.java',    Mode.JAVA);
  verifyMode('some/legacy.js',      Mode.JAVASCRIPT);  
  verifyMode('data.json',           Mode.JSON);
  verifyMode('styles.less',         Mode.LESS);
  verifyMode('flexible.lua',        Mode.LUA);
  verifyMode('README.md',           Mode.MARKDOWN);
  verifyMode('CHANGELOG.markdown',  Mode.MARKDOWN);
  verifyMode('server/run.php',      Mode.PHP);
  verifyMode('build.properties',    Mode.PROPERTIES);
  verifyMode('goog/devserver.py',   Mode.PYTHON);
  verifyMode('converter.rb',        Mode.RUBY);
  verifyMode('actor.scala',         Mode.SCALA);
  verifyMode('converter.scss',      Mode.SCSS);
  verifyMode('run.sh',              Mode.SH);
  verifyMode('flower.svg',          Mode.SVG);
  verifyMode('omg.ts',              Mode.TYPESCRIPT);
  verifyMode('verbose.xml',         Mode.XML);
  verifyMode('pubspec.yaml',        Mode.YAML);
  Mode.extensionMap.addAll({ 
    'a': Mode.DART,
    'b': Mode.COLDFUSION
  });
  verifyMode('custom.a',            Mode.DART);
  verifyMode('custom.b',            Mode.COLDFUSION);
}
