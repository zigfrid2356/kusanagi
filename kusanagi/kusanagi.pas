{
   kusanagi.pas
   
   Copyright 2018 Zigfrid2356 <zigfridone@gmail.com>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
}

{
* v1.0 
* 21-01-2018
* }

program kusanagi;

uses crt;
type
title=record
x,y:word;
color,tip:byte;
structure:char;
end;
map=record
m:array[0..50,0..10]of title;
end;

body=record
x,y,damage,exp:byte;
hp:integer;
end;

ai=record
a:array[0..9]of body;
end;
var 
kus:body;
monster,tm:ai;
i,j,temp : byte;
world:map;
menu_key,lang:char;

function lvl_up_menu(lum:body):body;
begin
repeat
 ClrScr;
if lang= 'e' then writeln	('KUSANAGI lvl up');
if lang= 'r' then writeln	('|<YCAHAI^U YPOBEHb');

if lang= 'e' then writeln	('1-up hp'{,text[4]});
if lang= 'e' then writeln	('2-up damage'{,text[16]});

if lang= 'r' then writeln	('1-3DOPOBEE'{,text[4]});
if lang= 'r' then writeln	('2-CUJIbHEE'{,text[16]});
//writeln	('3-exit'{,text[2]});
menu_key:=readkey;
case menu_key of
'1': begin
lum.hp:=lum.hp+5;
menu_key:='3';
end;
'2':begin 
lum.damage:=lum.damage+1;
menu_key:='3';
end;

end;
until menu_key='3';
lum.exp:=0;
lvl_up_menu:=lum;
end;

function battle(hb,mb:body):ai;
begin
repeat
mb.hp:=mb.hp-hb.damage;
hb.hp:=hb.hp-mb.damage;
until (hb.hp<=0)or(mb.hp<=0);
if hb.hp<=0 then exit;
hb.exp:=hb.exp+mb.exp;
if hb.exp>=1 then hb:=lvl_up_menu(hb);
 
battle.a[0]:=hb;
battle.a[1]:=mb;
end;

function hero_generate(command:byte;hg:body):body;
begin
{
* command
* 1-generate kusanagu lvl 0
* 2- generate monster
* 
* }
if command=1 then begin//1
hg.x:=1;
hg.y:=1;
hg.hp:=10;
hg.damage:=5;
hg.exp:=0;
end;//1
if command=2 then begin//2
hg.x:=random(20)+20;
hg.y:=random(8)+1;
hg.hp:=random(5)+1;
hg.damage:=1;
hg.exp:=random(10);
end;//2
hero_generate:=hg;
end;

function hero_muve(command:byte;hm:body;hmm:map):body;
begin
if (command=6) and (hm.x<45) and(hmm.m[hm.x+1,hm.y].tip <>2) 
then hm.x:=hm.x+1;

if (command=6) and (hm.x<45) and(hmm.m[hm.x+1,hm.y].tip =2) //jump
and (hmm.m[hm.x+1,hm.y-1].tip =0)and (hm.y>0)
then begin hm.x:=hm.x+1;hm.y:=hm.y-1;end;

if (command=4) and (hm.x>0) and(hmm.m[hm.x-1,hm.y].tip =1) 
then hm.x:=hm.x-1;

if (command=4) and (hm.x>0) and(hmm.m[hm.x-1,hm.y].tip =0) 
then hm.x:=hm.x-1;

if (command=4) and (hm.x>0) and(hmm.m[hm.x-1,hm.y].tip =2) //yump revers
and (hmm.m[hm.x-1,hm.y-1].tip =0)and (hm.y>0)
then begin hm.x:=hm.x-1;hm.y:=hm.y-1;end;

if (command=8) and (hm.y>0) and (hmm.m[hm.x,hm.y-1].tip =1)
then hm.y:=hm.y-1;
if (command=2) and (hm.y<10) and (hmm.m[hm.x,hm.y+1].tip <>2)
then hm.y:=hm.y+1;

if (command=8) and (hm.y>0) and (hm.y-1>0) and (hmm.m[hm.x+1,hm.y-1].tip =2)
then hm.y:=hm.y-1;

while (hmm.m[hm.x,hm.y].tip <>1) and (hmm.m[hm.x+1,hm.y].tip <>2)
and (hmm.m[hm.x,hm.y+1].tip <>2)
and(hm.y<10) do hm.y:=hm.y+1;

if (hm.y=10)and(hmm.m[hm.x,hm.y].tip <>1)  then begin 
hm.hp:=0;
hero_muve:=hm;
 ClrScr;
if lang= 'e' then writeln	('KUSANAGI RIP');
if lang= 'r' then writeln	('|<YCAHAI^U YMEPJIA');
readln;
exit;
end;
hero_muve:=hm;
end;

function map_generate(command:byte;mg:map):map;
var x,y,r:byte;
st:array[0..3]of char;

begin
{
* 0-full map generate
* 1-stolb map generate(49,X)
* 2- test (_) stolb map generate(49,X)
* }
st[0]:=' ';
st[1]:='_';
st[2]:='|';
st[3]:='+';

if command=0 then begin//0
for y:=0 to 10 do begin//0.0
mg.m[0,y].x:=0;
mg.m[0,y].y:=y;
mg.m[0,y].color:=1;
mg.m[0,y].tip:=1;
mg.m[0,y].structure:=st[random(3)];
end;//0.0

for y:=0 to 10 do begin//0.1
for x:=1 to 50 do begin//0.2
mg.m[x,y].x:=x;
mg.m[x,y].y:=y;
mg.m[x,y].color:=1;
mg.m[x,y].tip:=1;
if mg.m[x-1,y].structure=st[0] then begin//0.2.0
r :=random(10);
if (r>5)and(r<7) then mg.m[x,y].structure:=st[2];
if r>7 then mg.m[x,y].structure:=st[2] else mg.m[x,y].structure:=st[0];
end;//0.2.0
if mg.m[x-1,y].structure=st[1] then begin//0.2.1
r :=random(10);
if r>7 then mg.m[x,y].structure:=st[2] else mg.m[x,y].structure:=st[1];
end;//0.2.1
if mg.m[x-1,y].structure=st[2] then begin//0.2.2
r :=random(10);
if r>8 then mg.m[x,y].structure:=st[0]else mg.m[x,y].structure:=st[1];
end;//0.2.2
 //if (random(25)=5)and(mg.m[x,y].structure=st[1])then mg.m[x,y].structure:=st[3];


end;//0.1
end;//0.2
end;//0
if command=1 then begin//1
for y:=0 to 10 do begin//1.1
for x:=0 to 49 do begin//1.2
mg.m[x,y]:=mg.m[x+1,y]
end;//1.1
end;//1.2

for y:=0 to 10 do begin//1.3

mg.m[50,y].x:=50;
mg.m[50,y].y:=y;
mg.m[50,y].color:=1;
mg.m[50,y].tip:=1;


if mg.m[49,0].structure=st[1] then begin//1.3.0
r :=random(10);
if (r>5) then mg.m[50,0].structure:=st[0] else mg.m[50,0].structure:=st[1];
end;//1.3.0

if (mg.m[49,y].structure=st[1])and (mg.m[49,y+1].structure=st[1]) then 
 mg.m[50,y].structure:=st[2];

if (mg.m[49,y].structure=st[1])and (mg.m[49,y+1].structure=st[0])then 
 mg.m[50,0].structure:=st[1] ;

if mg.m[49,y+1].structure=st[2] then begin//1.3.0
r :=random(10);
if (r>5) then mg.m[50,y].structure:=st[0] else mg.m[50,y].structure:=st[1];
end;//1.3.0

if mg.m[49,y].structure=st[0] then begin//1.3.0
r :=random(10);
if (r>5) then mg.m[50,y].structure:=st[0] else mg.m[50,y].structure:=st[2];
end;//1.3.0

if (mg.m[49,y].structure=st[0])and (mg.m[49,y+1].structure=st[2]) then 
 mg.m[50,y].structure:=st[1];
 
if mg.m[49,y].structure=st[2] then 
 mg.m[50,y].structure:=st[0];
 
 if (random(25)=5)and(mg.m[50,y].structure=st[1])then mg.m[50,y].structure:=st[3];

end;//1.3
end;//1
if command=2 then begin//2
for y:=0 to 10 do begin//2.1
for x:=0 to 49 do begin//2.2
mg.m[x,y]:=mg.m[x+1,y]
end;//2.1
end;//2.2
for y:=0 to 10 do begin//0.0
mg.m[50,y].x:=50;
mg.m[50,y].y:=y;
mg.m[50,y].color:=1;
mg.m[50,y].tip:=1;
mg.m[50,y].structure:=st[1];
end;//0.0
end;//2
for y:=0 to 10 do begin//0.1
for x:=0 to 50 do begin//0.2

if mg.m[x,y].structure=st[0] then mg.m[x,y].tip:=0;
if mg.m[x,y].structure=st[2] then mg.m[x,y].tip:=2;
end;end;
map_generate:=mg;
end;

procedure map_output(mp:map;mph:body;mpm:ai;monster_nomber:byte);
begin

mp.m[mph.x,mph.y].structure:='@';//hero

//for temp:=0 to 0 do begin//monster
if mpm.a[monster_nomber].hp>0 then
mp.m[mpm.a[monster_nomber].x,mpm.a[monster_nomber].y].structure:='M';
//end;



textcolor(white);
if lang= 'e' then writeln('hp: ',mph.hp,' damage: ',mph.damage,' exp: ',mph.exp);
if lang= 'r' then writeln('3DOPOB: ',mph.hp,' YPOH: ',mph.damage,' OIIbIT: ',mph.exp);
//writeln (' mhp ',mpm.a[monster_nomber].hp,' # ',monster_nomber);
	writeln('|vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv|');
	for j:=0 to 10 do begin//2.0
	write('|');
	for i:=0 to 50 do begin //2.1
	
	if (i=mph.x)and(j=mph.y)then  textcolor(green);
	
	//for temp:=0 to 0 do begin
	if (i=mpm.a[monster_nomber].x)and(j=mpm.a[monster_nomber].y)
	and(mpm.a[monster_nomber].hp>0)
	then  textcolor(red);
	//end;
		
	write(mp.m[i,j].structure);
	textcolor(white);
			
	end;//2.1
	writeln('|');//
	end;//2.0
	writeln('|^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^|');
end;

function monster_muve(momu,momuhe:body;momuma:map):body;
begin
if (momu.x>momuhe.x)and (momuma.m[momu.x-1,momu.y].tip<>2) then 
momu.x:=momu.x-1;
if (momu.x<momuhe.x)and (momuma.m[momu.x+1,momu.y].tip<>2) then 
momu.x:=momu.x+1;

if (momu.x>momuhe.x)and (momuma.m[momu.x-1,momu.y].tip=2)and
(momuma.m[momu.x,momu.y-1].tip=1) and (momu.y>1)then 
momu.y:=momu.y-1;
if (momu.x<momuhe.x)and (momuma.m[momu.x+1,momu.y].tip=2)and
(momuma.m[momu.x,momu.y+1].tip=1)and (momu.y+1<10) then 
momu.y:=momu.y+1;

if (momu.x>momuhe.x)and (momuma.m[momu.x-1,momu.y].tip=2)and
(momuma.m[momu.x,momu.y-1].tip<>1)and (momuma.m[momu.x,momu.y+1].tip<>2)
and (momu.y+1<10) then 
momu.y:=momu.y+1;
if (momu.x<momuhe.x)and (momuma.m[momu.x+1,momu.y].tip=2)and
(momuma.m[momu.x,momu.y-1].tip<>1)and (momuma.m[momu.x,momu.y+1].tip<>2)
and (momu.y+1<10) then 
momu.y:=momu.y+1;

if (momu.y>momuhe.y)and (momuma.m[momu.x,momu.y-1].tip=1)
and (momu.y-1>0) then momu.y:=momu.y-1;
if (momu.y<momuhe.y)and (momuma.m[momu.x,momu.y+1].tip<>2)
and (momu.y+1<10) then momu.y:=momu.y+1;

while (momuma.m[momu.x,momu.y].tip <>1) and (momuma.m[momu.x+1,momu.y].tip <>2)
and (momuma.m[momu.x,momu.y+1].tip <>2)
and(momu.y<10) do momu.y:=momu.y+1;

monster_muve:=momu;
end;


function main_menu(mm:map):map;
var mmt:byte;
begin
mmt:=0;
repeat begin//1
ClrScr;
map_output(mm,kus,monster,mmt);

while not monster.a[mmt].hp>=0 do mmt:=mmt+1;
if monster.a[mmt].hp=0 then mmt:=mmt+1;
if mmt>9 then begin//2
 mmt:=0; 
 for temp:=0 to 9 do
monster.a[temp]:=hero_generate(2,monster.a[temp]);
 end;//2

if (kus.x=monster.a[mmt].x)and(kus.y=monster.a[mmt].y) 
and (monster.a[mmt].hp>0) 
then begin
tm:=battle(kus,monster.a[mmt]);
kus:=tm.a[0];
monster.a[mmt]:=tm.a[1];
ClrScr;
map_output(mm,kus,monster,mmt);
end;

if mm.m[kus.x,kus.y].structure='+' then begin
kus.hp:=kus.hp+5;
mm.m[kus.x,kus.y].structure:='_';
end;

writeln	('2- v'{,text[10]});
writeln	('4- <'{,text[9]});
writeln	('6- >'{,text[17]});
writeln	('8- ^'{,text[2]});
if lang= 'e' then writeln	('3- exit'{,text[107]});
if lang= 'r' then writeln	('3- BbIXOD'{,text[2]});
menu_key:=readkey;
case menu_key of
'2': begin //1.1
	kus:=hero_muve(2,kus,mm);
	monster.a[mmt]:=monster_muve(monster.a[mmt],kus,mm);
	end;//1.1
'4':	begin//1.2
	kus:=hero_muve(4,kus,mm);
	monster.a[mmt]:=monster_muve(monster.a[mmt],kus,mm);
	end;//1.2
'6': begin//1.4
	kus:=hero_muve(6,kus,mm);
	monster.a[mmt]:=monster_muve(monster.a[mmt],kus,mm);
	if (kus.x>=45) and (mm.m[kus.x+1,kus.y].tip<>2) 
	then begin
	mm:=map_generate(1,mm);
	if monster.a[mmt].x-1>0 then monster.a[mmt].x:=monster.a[mmt].x-1
	else monster.a[mmt].hp:=0;
	end;

end;//1.4
'8': begin//1.5
	kus:=hero_muve(8,kus,mm);
	monster.a[mmt]:=monster_muve(monster.a[mmt],kus,mm);
end;//1.5
end;
end;//2
main_menu:=mm;
until (menu_key='3')or (kus.hp<=0);
main_menu:=mm;
end;

procedure options_menu;
begin
repeat
 ClrScr;
if lang= 'e' then writeln	('OPTIONS');
if lang= 'e' then writeln	('1-rus'{,text[4]});
if lang= 'e' then writeln	('2-eng'{,text[16]});
if lang= 'e' then writeln	('3-exit'{,text[2]});

if lang= 'r' then writeln	('OPU,UU');
if lang= 'r' then writeln	('1-PYC'{,text[4]});
if lang= 'r' then writeln	('2-AHI^/\'{,text[16]});
if lang= 'r' then writeln	('3-BbIXOD'{,text[2]});
menu_key:=readkey;
case menu_key of
'1': begin
lang:='r';
menu_key:='3';
end;
'2':begin 
lang:='e';
menu_key:='3';
end;

end;
until menu_key='3';
menu_key:='8';
end;

function zero_menu(zmc:char):map;
begin
repeat
 ClrScr;
if lang= 'e' then writeln	('KUSANAGI');
if lang= 'e' then writeln	('1-start'{,text[4]});
if lang= 'e' then writeln	('2-options'{,text[16]});
if lang= 'e' then writeln	('3-exit'{,text[2]});

if lang= 'r' then writeln	('|<YCAHAI^U');
if lang= 'r' then writeln	('1-CTAPT'{,text[4]});
if lang= 'r' then writeln	('2-OPU,UU'{,text[16]});
if lang= 'r' then writeln	('3-BbIXOD'{,text[2]});
menu_key:=readkey;
case menu_key of
'1': begin
zero_menu:=map_generate(0,world);
menu_key:='3';
end;
'2':begin 
options_menu;
//menu_key:='3';
end;
'3':begin 
temp:=100;
end;

end;
until (menu_key='3')or(kus.hp<0);

end;
BEGIN
lang:='e';temp:=0;
randomize;
kus:=hero_generate(1,kus);
for temp:=0 to 9 do
monster.a[temp]:=hero_generate(2,monster.a[temp]);
world:=zero_menu('s');
if temp=100 then exit;
world:=main_menu(world);
ClrScr;
if kus.hp<=0 then writeln	('You LOOser'{,text[2]});
writeln	('"Enter" - exit'{,text[2]});
	readln();
	
END.

