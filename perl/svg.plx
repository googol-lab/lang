#!/usr/bin/perl -w
use strict;
use encoding "euc-jp", STDOUT => "utf8";
use SVG;

# create an SVG object
my $svg= SVG->new(width=>200,height=>200);

# use explicit element constructor to generate a group element
my $y=$svg->group(
		  id    => 'group_y',
		  style => { stroke=>'red', fill=>'green' }
		 );

# add a circle to the group
$y->circle(cx=>100, cy=>100, r=>50, id=>'circle_in_group_y');

# or, use the generic 'tag' method to generate a group element by name
my $z=$svg->tag('g',
		id    => 'group_z',
		style => {
			  stroke => 'rgb(100,200,50)',
			  fill   => 'rgb(10,100,150)'
			 }
	       );

# create and add a circle using the generic 'tag' method
$z->tag('circle', cx=>50, cy=>50, r=>100, id=>'circle_in_group_z');

# create an anchor on a rectangle within a group within the group z
my $k = $z->anchor(
		   id      => 'anchor_k',
		   -href   => 'http://test.hackmare.com/',
		   target => 'new_window_0'
		  )->rectangle(
			       x     => 20, y      => 50,
			       width => 20, height => 30,
			       rx    => 10, ry     => 5,
			       id    => 'rect_k_in_anchor_k_in_group_z'
			      );

# create an anchor on a rectangle within a group within the group z

my $j = $svg->rectangle(x=>20,y=>20,width=>30,height=>40,style=>{fill=>'white'});

my $text = $svg->text(
		      x=>0,y=>20,
		      style => {
				'font'      => 'Arial',
				'font-size' => 20,
				'fill' => 'yellow'
			       },
		     )->cdata("����ϥƥ��ȡ�");

my $xv = [0,20,40,50,10];
my $yv = [0,0,20,200,50];

my $points = $svg->get_path(
		       x=>$xv, y=>$yv,
		       -type=>'polygon'
		      );

my $c = $svg->polygon(
		 %$points,
		 id=>'pgon1');

# now render the SVG object, implicitly use svg namespace
print $svg->xmlify;
