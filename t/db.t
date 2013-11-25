#!/usr/bin/perl -w

use strict;
use Test::More;
use utf8;
use URI;
use URI::QueryParam;

for my $spec (
    [ db         => undef ],
    [ pg         => 5432  ],
    [ mysql      => 3306  ],
    [ sqlite     => undef ],
    [ oracle     => 1521  ],
    [ cubrid     => 1523  ], # ?
    [ firebird   => 3050  ],
    [ sqlserver  => 1433  ],
    [ db2        => 50000 ], # ?
    [ ingres     => 1524  ],
    [ sybase     => 2638  ],
    [ informix   => 1526  ], # ?
    [ teradata   => 1025  ],
    [ interbase  => 3050  ],
    [ unify      => 27117 ], # ?
    [ mongodb    => 27017 ],
    [ monetdb    => 50000 ], # ?
    [ maxdb      => 7673  ], # ?
    [ impala     => 21000 ],
    [ couchdb    => 5984  ],
    [ hive       => 10000 ],
    [ cassandra  => 9160  ],
    [ derby      => 1527  ],
    [ vertica    => 5433  ],
) {
    my ($engine, $port) = @{ $spec };
    my $prefix = "db:$engine";
    my $class  = "URI::db::$engine";
    my $label  = $engine;
    if ($engine eq 'db') {
        $prefix = 'db';
        $class  = 'URI::db';
        $engine = undef;
        $label  = '';
    }

    isa_ok my $uri = URI->new("$prefix:"), $class;
    isa_ok $uri, 'URI::db' unless $prefix eq 'db';
    is $uri->scheme, 'db', 'Scheme should be "db"';
    is $uri->engine, $engine, qq{Simple URI engine should be "$label"};
    is $uri->db_name, undef, 'Simple URI db name should be undef';
    is $uri->host, undef, 'Simple URI host should be undef';
    is $uri->port, $port, 'Simple URI port should be undef';
    is $uri->user, undef, 'Simple URI user should be undef';
    is $uri->password, undef, 'Simple URI password should be undef';
    is_deeply $uri->query_form_hash, {},
        'Simple URI query params should be empty by default';
    is $uri->as_string, "$prefix:", 'Simple URI string should be correct';
    is "$uri", "$prefix:", 'Simple URI should correctly strigify';

    isa_ok $uri = URI->new("$prefix:foo.db"), $class;
    isa_ok $uri, 'URI::db' unless $prefix eq 'db';
    is $uri->scheme, 'db', 'Scheme should be "db"';
    is $uri->engine, $engine, qq{Path URI engine should be "$label"};
    is $uri->db_name, 'foo.db', 'Path URI db name should be "foo.db"';
    is $uri->host, undef, 'Path URI host should be undef';
    is $uri->port, $port, 'Path URI port should be undef';
    is $uri->user, undef, 'Path URI user should be undef';
    is $uri->password, undef, 'Path URI password should be undef';
    is_deeply $uri->query_form_hash, {},
        'Path URI query params should be empty by default';
    is $uri->as_string, "$prefix:foo.db", 'Path URI string should be correct';
    is "$uri", "$prefix:foo.db", 'Simple URI should correctly strigify';

    isa_ok $uri = URI->new("$prefix:/path/to/foo.db"), $class;
    isa_ok $uri, 'URI::db' unless $prefix eq 'db';
    is $uri->scheme, 'db', 'Scheme should be "db"';
    is $uri->engine, $engine, qq{Absolute Path URI engine should be "$label"};
    is $uri->db_name, '/path/to/foo.db',
        'Absolute Path URI db name should be "/path/to/foo.db"';
    is $uri->host, undef, 'Absolute Path URI host should be undef';
    is $uri->port, $port, 'Absolute Path URI port should be undef';
    is $uri->user, undef, 'Absolute Path URI user should be undef';
    is $uri->password, undef, 'Absolute Path URI password should be undef';
    is_deeply $uri->query_form_hash, {},
        'Absolute Path URI query params should be empty by default';
    is $uri->as_string, "$prefix:/path/to/foo.db",
        'Absolute Path URI string should be correct';
    is "$uri", "$prefix:/path/to/foo.db",
        'Simple URI should correctly strigify';

    isa_ok $uri = URI->new("$prefix://"), $class;
    is $uri->engine, $engine, qq{Hostless URI engine should be "label"};
    is $uri->db_name, undef, 'Hostless URI db name should be undef';
    is $uri->host, '', 'Hostless URI host should be ""';
    is $uri->port, $port, 'Hostless URI port should be undef';
    is $uri->user, undef, 'Hostless URI user should be undef';
    is $uri->password, undef, 'Hostless URI password should be undef';
    is_deeply $uri->query_form_hash, {},
        'Hostless URI query params should be empty by default';
    is $uri->as_string, "$prefix://", 'Hostless URI string should be correct';
    is "$uri", "$prefix://", 'Hostless URI should correctly strigify';

    isa_ok $uri = URI->new("$prefix://localhost"), $class;
    is $uri->engine, $engine, qq{Localhost URI engine should be "label"};
    is $uri->db_name, undef, 'Localhost URI db name should be undef';
    is $uri->host, 'localhost', 'Localhost URI host should be "localhost"';
    is $uri->port, $port, 'Localhost URI port should be undef';
    is $uri->user, undef, 'Localhost URI user should be undef';
    is $uri->password, undef, 'Localhost URI password should be undef';
    is_deeply $uri->query_form_hash, {},
        'Localhost URI query params should be empty by default';
    is $uri->as_string, "$prefix://localhost",
        'Localhost URI string should be correct';
    is "$uri", "$prefix://localhost",
        'Localhost URI should correctly strigify';

    isa_ok $uri = URI->new("$prefix://example.com:5433"), $class;
    is $uri->engine, $engine, qq{Host+Port URI engine should be "label"};
    is $uri->db_name, undef, 'Host+Port URI db name should be undef';
    is $uri->host, 'example.com', 'Host+Port URI host should be "example.com"';
    is $uri->port, 5433, 'Host+Port URI port should be 5433';
    is $uri->user, undef, 'Host+Port URI user should be undef';
    is $uri->password, undef, 'Host+Port URI password should be undef';
    is_deeply $uri->query_form_hash, {},
        'Host+Port URI query params should be empty by default';
    is $uri->as_string, "$prefix://example.com:5433",
        'Host+Port URI string should be correct';
    is "$uri", "$prefix://example.com:5433",
        'Host+Port URI should correctly strigify';

    isa_ok $uri = URI->new("$prefix://example.com/mydb"), $class;
    is $uri->engine, $engine, qq{DB URI engine should be "label"};
    is $uri->db_name, 'mydb', 'DB URI db name should be "mydb"';
    is $uri->host, 'example.com', 'DB URI host should be "example.com"';
    is $uri->port, $port, 'DB URI port should be undef';
    is $uri->user, undef, 'DB URI user should be undef';
    is $uri->password, undef, 'DB URI password should be undef';
    is_deeply $uri->query_form_hash, {}, 'DB URI query params should be empty by default';
    is $uri->as_string, "$prefix://example.com/mydb",
        'DB URI string should be correct';
    is "$uri", "$prefix://example.com/mydb",
        'DB URI should correctly strigify';

    isa_ok $uri = URI->new("$prefix://user\@localhost//fullpathdb"), $class;
    is $uri->engine, $engine, qq{User URI engine should be "label"};
    is $uri->db_name, '/fullpathdb', 'User URI db name should be "/fullpathdb"';
    is $uri->host, 'localhost', 'User URI host should be "localhost"';
    is $uri->port, $port, 'User URI port should be undef';
    is $uri->user, 'user', 'User URI user should be "user"';
    is $uri->password, undef, 'User URI password should be undef';
    is_deeply $uri->query_form_hash, {}, 'User URI query params should be empty by default';
    is $uri->as_string, "$prefix://user\@localhost//fullpathdb",
        'User URI string should be correct';
    is "$uri", "$prefix://user\@localhost//fullpathdb",
        'User URI should correctly strigify';

    isa_ok $uri = URI->new("$prefix://user:secret\@localhost"), $class;
    is $uri->engine, $engine, qq{Password URI engine should be "label"};
    is $uri->db_name, undef, 'Password URI db name should be undef';
    is $uri->host, 'localhost', 'Password URI host should be "localhost"';
    is $uri->port, $port, 'Password URI port should be undef';
    is $uri->user, 'user', 'Password URI user should be "user"';
    is $uri->password, 'secret', 'Password URI password should be "secret"';
    is_deeply $uri->query_form_hash, {}, 'Password URI query params should be empty by default';
    is $uri->as_string, "$prefix://user:secret\@localhost",
        'Password URI string should be correct';
    is "$uri", "$prefix://user:secret\@localhost",
        'Password URI should correctly strigify';

    isa_ok $uri = URI->new("$prefix://other\@localhost/otherdb?foo=bar&baz=yow"),
        $class;
    is $uri->engine, $engine, qq{Query URI engine should be "label"};
    is $uri->db_name, 'otherdb', 'Query URI db name should be "otherdb"';
    is $uri->host, 'localhost', 'Query URI host should be "localhost"';
    is $uri->port, $port, 'Query URI port should be undef';
    is $uri->user, 'other', 'Query URI user should be "other"';
    is $uri->password, undef, 'Query URI password should be undef';
    is_deeply $uri->query_form_hash, { foo => 'bar', baz => 'yow'},
        'Query URI query params should be populated';
    is $uri->as_string, "$prefix://other\@localhost/otherdb?foo=bar&baz=yow",
        'Query URI string should be correct';
    is "$uri", "$prefix://other\@localhost/otherdb?foo=bar&baz=yow",
        'Query URI should correctly strigify';
}

done_testing;
