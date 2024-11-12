import 'package:flutter_test/flutter_test.dart' as t;

import 'package:pub_api_client/pub_api_client.dart' as pac;

import 'package:pub_dev_browser_lib/src/parsed_search.dart' as ps;
import 'package:pub_dev_browser_lib/src/search_parser.dart' as sp;

void main() {
  t.group('SearchParser()', () {
    t.test('parse() empty', () {
      t.expect(
        const sp.SearchParser('sort:top').parse(),
        ps.ParsedSearch(
          query: '',
          tags: List.empty(),
          topics: List.empty(),
          sort: pac.SearchOrder.top,
        ),
      );
    });

    t.test('parse() `PackageTag`s', () {
      t.expect(
        const sp.SearchParser(
                'dependency:dependency has:has is:is license:license platform:ios publisher:publisher sdk:dart show:show sort:top')
            .parse(),
        ps.ParsedSearch(
          query: '',
          tags: const [
            'dependency:dependency',
            'has:has',
            'is:is',
            'license:license',
            'platform:ios',
            'publisher:publisher',
            'sdk:dart',
            'show:show',
          ],
          topics: List.empty(),
          sort: pac.SearchOrder.top,
        ),
      );
    });

    t.test('parse() dotted publisher name', () {
      t.expect(
        const sp.SearchParser('publisher:foo.bar publisher:baz.qux sort:top')
            .parse(),
        ps.ParsedSearch(
          query: '',
          tags: const ['publisher:foo.bar', 'publisher:baz.qux'],
          topics: List.empty(),
          sort: pac.SearchOrder.top,
        ),
      );
    });

    t.test('parse() `topic`s', () {
      t.expect(
        const sp.SearchParser('topic:foo topic:bar topic:baz sort:top').parse(),
        ps.ParsedSearch(
          query: '',
          tags: List.empty(),
          topics: const ['foo', 'bar', 'baz'],
          sort: pac.SearchOrder.top,
        ),
      );
    });

    t.test('parse() mixed', () {
      t.expect(
        const sp.SearchParser(
                'topic:foo dependency:bar topic:baz has:qux topic:quux sort:top')
            .parse(),
        const ps.ParsedSearch(
          query: '',
          tags: ['dependency:bar', 'has:qux'],
          topics: ['foo', 'baz', 'quux'],
          sort: pac.SearchOrder.top,
        ),
      );
    });

    t.test('parse() mixed with query', () {
      t.expect(
        const sp.SearchParser(
                'topic:foo zero dependency:bar topic:baz one has:qux two topic:quux three sort:top')
            .parse(),
        const ps.ParsedSearch(
          query: 'zero one two three',
          tags: ['dependency:bar', 'has:qux'],
          topics: ['foo', 'baz', 'quux'],
          sort: pac.SearchOrder.top,
        ),
      );
    });

    t.test('parse() mixed with query and whitespace', () {
      t.expect(
        const sp.SearchParser(
                '   zero    topic:foo one dependency:bar    topic:baz two has:qux   three    topic:quux four  sort:top  ')
            .parse(),
        const ps.ParsedSearch(
          query: 'zero one two three four',
          tags: ['dependency:bar', 'has:qux'],
          topics: ['foo', 'baz', 'quux'],
          sort: pac.SearchOrder.top,
        ),
      );
    });
    t.group('sort specifier', () {
      t.test('parse() sort:top', () {
        t.expect(
          const sp.SearchParser('sort:top').parse(),
          ps.ParsedSearch(
            query: '',
            tags: List.empty(),
            topics: List.empty(),
            sort: pac.SearchOrder.top,
          ),
        );
      });

      t.test('parse() sort:text', () {
        t.expect(
          const sp.SearchParser('sort:text').parse(),
          ps.ParsedSearch(
            query: '',
            tags: List.empty(),
            topics: List.empty(),
            sort: pac.SearchOrder.text,
          ),
        );
      });

      t.test('parse() sort:created', () {
        t.expect(
          const sp.SearchParser('sort:created').parse(),
          ps.ParsedSearch(
            query: '',
            tags: List.empty(),
            topics: List.empty(),
            sort: pac.SearchOrder.created,
          ),
        );
      });

      t.test('parse() sort:updated', () {
        t.expect(
          const sp.SearchParser('sort:updated').parse(),
          ps.ParsedSearch(
            query: '',
            tags: List.empty(),
            topics: List.empty(),
            sort: pac.SearchOrder.updated,
          ),
        );
      });

      t.test('parse() sort:popularity', () {
        t.expect(
          const sp.SearchParser('sort:popularity').parse(),
          ps.ParsedSearch(
            query: '',
            tags: List.empty(),
            topics: List.empty(),
            sort: pac.SearchOrder.popularity,
          ),
        );
      });

      t.test('parse() sort:likes', () {
        t.expect(
          const sp.SearchParser('sort:likes').parse(),
          ps.ParsedSearch(
            query: '',
            tags: List.empty(),
            topics: List.empty(),
            sort: pac.SearchOrder.like,
          ),
        );
      });

      t.test('parse() sort:points', () {
        t.expect(
          const sp.SearchParser('sort:points').parse(),
          ps.ParsedSearch(
            query: '',
            tags: List.empty(),
            topics: List.empty(),
            sort: pac.SearchOrder.points,
          ),
        );
      });
    });

    t.group('exceptions', () {
      t.test('invalid platform', () {
        t.expect(
          () => const sp.SearchParser('platform:foo').parse(),
          t.throwsA(t.isA<sp.InvalidPlatformException>()),
        );
      });

      t.test('invalid sdk', () {
        t.expect(
          () => const sp.SearchParser('sdk:foo').parse(),
          t.throwsA(t.isA<sp.InvalidSdkTagException>()),
        );
      });

      t.test('invalid sort specifier', () {
        t.expect(
          () => const sp.SearchParser('sort:foo').parse(),
          t.throwsA(t.isA<sp.InvalidSortSpecifierException>()),
        );
      });

      t.test('no sorts', () {
        t.expect(
          () => const sp.SearchParser('').parse(),
          t.throwsA(t.isA<sp.InvalidNumberOfSortsException>()),
        );
      });

      t.test('multiple sorts', () {
        t.expect(
          () => const sp.SearchParser('sort:top sort:text').parse(),
          t.throwsA(t.isA<sp.InvalidNumberOfSortsException>()),
        );
      });
    });
  });
}
