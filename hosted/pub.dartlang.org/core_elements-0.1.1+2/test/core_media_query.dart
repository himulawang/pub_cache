//Copyright (c) 2014 The Polymer Project Authors. All rights reserved.
//This code may only be used under the BSD style license found at http://polymer.github.io/LICENSE.txt
//The complete set of authors may be found at http://polymer.github.io/AUTHORS.txt
//The complete set of contributors may be found at http://polymer.github.io/CONTRIBUTORS.txt
//Code distributed by Google as part of the polymer project is also
//subject to an additional IP rights grant found at http://polymer.github.io/PATENTS.txt

library core_media_query.test;

import 'dart:html' as dom;
import 'dart:async' as async;
import 'dart:js' as js;
import 'package:polymer/polymer.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart' show useHtmlConfiguration;

void main() {
  useHtmlConfiguration();

  initPolymer().run(() {
    return Polymer.onReady.then((_) {

      group('core-media-query', () {

        test('basic', () {
          const WIDTHS = const [500, 1000, 700, 300, 700];
          const IS_PHONE = const [true, false, false, true, false];
          const IS_TABLET = const [false, true, true, false, true];
          var done = expectAsync(() {});
          var dialog;
          dom.window.onMessage.listen((e) {
            // ignore messages the unittest runner sends internally
            if (e.data is Map && (e.data as Map).containsKey('message_id')) {
              int messageId = e.data['message_id'];
              // increase the test data index because
              // resize from 1000 to 700 doesn't produce a message
              if (messageId >= 2) messageId++;

              expect(e.data['width'], WIDTHS[messageId]);
              expect(e.data['phone'], equals(IS_PHONE[messageId]));
              expect(e.data['tablet'], equals(IS_TABLET[messageId]));

              // resize from 1000 to 700 doesn't produce a message
              // just send another resize
              if (messageId == 1) {
                new async.Future(
                // TODO(zoechi) workaround for issue 20216
                // () => dialog.resizeTo(WIDTHS[messageId + 2], 700));
                () =>
                    dialog.callMethod('resizeTo', [WIDTHS[messageId + 2], 700]));
              }

              if (messageId < 4) {
                // TODO(zoechi) workaround for issue 20216
                //dialog.resizeTo(WIDTHS[messageId + 1], 700);
                dialog.callMethod('resizeTo', [WIDTHS[messageId + 1], 700]);
              } else {
                // TODO(zoechi) workaround for issue 20216
                //dialog.close();
                dialog.callMethod('close');
                done();
              }
            }
          });

          // TODO(zoechi) workaround for issue 20216
          // dialog = dom.window.open(
          //   'core_media_query_dialog.html', '_blank') as dom.Window;
          // dialog.resizeTo(WIDTHS[0], 700);
          dialog = new js.JsObject(js.context['OpenDialogWorkaround']);
          dialog.callMethod('open', ['core_media_query_dialog.html', '_blank']);
          dialog.callMethod('resizeTo', [WIDTHS[0], 700]);
        });

      });

    });
  });
}
