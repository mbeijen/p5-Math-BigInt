#!/usr/bin/perl -w

use strict;
use Test;

BEGIN 
  {
  $| = 1;
  # chdir 't' if -d 't';
  unshift @INC, '../lib'; # for running manually
  plan tests => 51;
  }

# testing of Math::BigInt::BitVect, primarily for interface/api and not for the
# math functionality

use Math::BigInt::Scalar;

my $C = 'Math::BigInt::Scalar';	# pass classname to sub's

# _new and _str
my $x = _new($C,\"123"); my $y = _new($C,\"321");
ok (ref($x),'SCALAR'); ok (${_str($C,$x)},123); ok (${_str($C,$y)},321);

# _add, _sub, _mul, _div

ok (${_str($C,_add($C,$x,$y))},444);
ok (${_str($C,_sub($C,$x,$y))},123);
ok (${_str($C,_mul($C,$x,$y))},39483);
ok (${_str($C,_div($C,$x,$y))},123);

ok (${_str($C,_mul($C,$x,$y))},39483);
ok (${_str($C,$x)},39483);
ok (${_str($C,$y)},321);
my $z = _new($C,\"2");
ok (${_str($C,_add($C,$x,$z))},39485);
my ($re,$rr) = _div($C,$x,$y);

ok (${_str($C,$re)},123); ok (${_str($C,$rr)},2);

# is_zero, _is_one, _one, _zero
ok (_is_zero($C,$x),0);
ok (_is_one($C,$x),0);

ok (_is_one($C,_one()),1); ok (_is_one($C,_zero()),0);
ok (_is_zero($C,_zero()),1); ok (_is_zero($C,_one()),0);

# is_odd, is_even
ok (_is_odd($C,_one()),1); ok (_is_odd($C,_zero()),0);
ok (_is_even($C,_one()),0); ok (_is_even($C,_zero()),1);

# _digit
$x = _new($C,\"123456789");
ok (_digit($C,$x,0),9);
ok (_digit($C,$x,1),8);
ok (_digit($C,$x,2),7);
ok (_digit($C,$x,-1),1);
ok (_digit($C,$x,-2),2);
ok (_digit($C,$x,-3),3);

# _copy
$x = _new($C,\"12356");
ok (${_str($C,_copy($C,$x))},12356);

# _acmp
$x = _new($C,\"123456789");
$y = _new($C,\"987654321");
ok (_acmp($C,$x,$y),-1);
ok (_acmp($C,$y,$x),1);
ok (_acmp($C,$x,$x),0);
ok (_acmp($C,$y,$y),0);

# _div
$x = _new($C,\"3333"); $y = _new($C,\"1111");
ok (${_str($C, scalar _div($C,$x,$y))},3);
$x = _new($C,\"33333"); $y = _new($C,\"1111"); ($x,$y) = _div($C,$x,$y);
ok (${_str($C,$x)},30); ok (${_str($C,$y)},3);
$x = _new($C,\"123"); $y = _new($C,\"1111"); 
($x,$y) = _div($C,$x,$y); ok (${_str($C,$x)},0); ok (${_str($C,$y)},123);

# _num
$x = _new($C,\"12345"); $x = _num($C,$x); ok (ref($x)||'',''); ok ($x,12345);

# _len
$x = _new($C,\"12345"); $x = _len($C,$x); ok (ref($x)||'',''); ok ($x,5);

# _and, _or, _xor
$x = _new($C,\"3"); $y = _new($C,\"4"); ok (${_str($C, _or($C,$x,$y))},7);
$x = _new($C,\"1"); $y = _new($C,\"4"); ok (${_str($C, _xor($C,$x,$y))},5);
$x = _new($C,\"7"); $y = _new($C,\"3"); ok (${_str($C, _and($C,$x,$y))},3);

# _pow
$x = _new($C,\"2"); $y = _new($C,\"4"); ok (${_str($C, _pow($C,$x,$y))},16);
$x = _new($C,\"2"); $y = _new($C,\"5"); ok (${_str($C, _pow($C,$x,$y))},32);
$x = _new($C,\"3"); $y = _new($C,\"3"); ok (${_str($C, _pow($C,$x,$y))},27);


# should not happen:
# $x = _new($C,\"-2"); $y = _new($C,\"4"); ok (_acmp($C,$x,$y),-1);

# _check
$x = _new($C,\"123456789");
ok (_check($C,$x),0);
ok (_check($C,123),'123 is not a reference');

# done

1;

