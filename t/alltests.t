#!/usr/bin/perl -w

# simple tests for HTML::QuickTable

use strict;

use Test;
BEGIN { plan tests => 5 };

use HTML::QuickTable;

my @tests = (
    {
        new => {
            font => 'arial',
        },
        dat => [ [ 1..4 ], [6 .. 9] ],
        res => '<table>
<tr><td><font face="arial">1</font></td><td><font face="arial">2</font></td><td><font face="arial">3</font></td><td><font face="arial">4</font></td></tr>
<tr><td><font face="arial">6</font></td><td><font face="arial">7</font></td><td><font face="arial">8</font></td><td><font face="arial">9</font></td></tr>
</table>',
    },

    {
        new => {
            font => 'arial',
            font_size => '+3',
            td => { class => 'myClass' },
            th => { class => 'heading', bgcolor => 'gray' },
            table => { width => '100%' },
            labels => 1,
        },
        dat => [ [qw/one two three four/], [qw/five six seven eight/], [qw/nine ten eleven twelve/] ],
        res => '<table width="100%">
<tr><th bgcolor="gray" class="heading"><font face="arial" size="+3">one</font></th><th bgcolor="gray" class="heading"><font face="arial" size="+3">two</font></th><th bgcolor="gray" class="heading"><font face="arial" size="+3">three</font></th><th bgcolor="gray" class="heading"><font face="arial" size="+3">four</font></th></tr>
<tr><td class="myClass"><font face="arial" size="+3">five</font></td><td class="myClass"><font face="arial" size="+3">six</font></td><td class="myClass"><font face="arial" size="+3">seven</font></td><td class="myClass"><font face="arial" size="+3">eight</font></td></tr>
<tr><td class="myClass"><font face="arial" size="+3">nine</font></td><td class="myClass"><font face="arial" size="+3">ten</font></td><td class="myClass"><font face="arial" size="+3">eleven</font></td><td class="myClass"><font face="arial" size="+3">twelve</font></td></tr>
</table>',
    },

    {
        new => {
            table_width => '95%',
            border => 0,
            table_cellpadding => '3',
            table_cellspacing => '5',
            lalign => 'right',
            labels => 1,
        },
        # can only test hash pairs, since anything else may be reordered!
        dat => [ {qw/one two/}, {qw/five six/}, {qw/nine ten/} ],
        res => '<table border="0" cellpadding="3" cellspacing="5" width="95%">
<tr><th align="right"><table width="100%">
<tr><th align="right">one</th></tr>
<tr><th align="right">two</th></tr>
</table></th></tr>
<tr><td><table width="100%">
<tr><td>five</td></tr>
<tr><td>six</td></tr>
</table></td></tr>
<tr><td><table width="100%">
<tr><td>nine</td></tr>
<tr><td>ten</td></tr>
</table></td></tr>
</table>',
    },

    {
        new => {
            labels => 'L',
            vertical => 1,
            table_width => '99%',
            header => 1,
            body => {text => 'red', bgcolor => 'black'},
        },
        dat => [ 
                 ['User', 'Name', 'Ext', 'Email'],
                 [ 'nwiger', 'Nathan Wiger', 'x43264', 'nate@wiger.org' ],
                 [ 'jbobson', 'Jim Bobson', 'x92811', 'jim@bobson.com' ],
               ],
        res => 'Content-type: text/html

<html><head></head><body bgcolor="black" text="red"><font><table width="99%">
<tr><th>User</th><td>nwiger</td><td>jbobson</td></tr>
<tr><th>Name</th><td>Nathan Wiger</td><td>Jim Bobson</td></tr>
<tr><th>Ext</th><td>x43264</td><td>x92811</td></tr>
<tr><th>Email</th><td>nate@wiger.org</td><td>jim@bobson.com</td></tr>
</table></font></body></html>
',
    },

    {
        new => {
            htmlize => 1,
            title => 'Tacos for everyone',
            null => 'N/A',
            nulltags => {bgcolor => 'gray'},
            header => 1,
            text => 'Hey there!',
            vertical => 1,
            labels => 'R',
        },
        dat => [ 
                 ['User', 'Name', 'Ext', 'Email'],
                 [ 'nwiger', 'Nathan Wiger', undef, 'nate@wiger.org' ],
                 [ 'jbobson', undef, 'x92811', 'jim@bobson.com' ],
               ],
        res => 'Content-type: text/html

<html><head><title>Tacos for everyone</title></head><body bgcolor="white"><font><h3>Tacos for everyone</h3>Hey there!<table>
<tr><td>User</td><td>nwiger</td><th>jbobson</th></tr>
<tr><td>Name</td><td>Nathan Wiger</td><th bgcolor="gray">N/A</th></tr>
<tr><td>Ext</td><td bgcolor="gray">N/A</td><th>x92811</th></tr>
<tr><td>Email</td><td><a href="mailto:nate@wiger.org">nate@wiger.org</a></td><th><a href="mailto:jim@bobson.com">jim@bobson.com</a></th></tr>
</table></font></body></html>
',
    },

);

for (@tests) {
    my $qt = HTML::QuickTable->new(%{$_->{new}});
    #warn "ok($qt->render($_->{dat}), $_->{res});";
    ok($qt->render($_->{dat}), $_->{res});
}

