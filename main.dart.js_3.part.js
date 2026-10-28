((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aUM(d){var x,w,v
switch(d.w.a){case 1:x=d.c
w=x!=null?new A.e1(0,x.gn0()):C.hM
break
case 0:x=d.d
w=d.c
if(x!=null){v=w==null?null:w.gn0()
w=new A.dc(x,v==null?C.r:v)}else if(w==null)w=D.oK
break
default:w=null}return new B.hT(d.a,d.f,d.b,d.e,w)},
asK(d,e,f){var x,w,v,u,t,s,r,q,p=null
if(d==e)return d
x=d==null
if(!x&&e!=null){if(f===0)return d
if(f===1)return e}w=x?p:d.b
v=e==null
u=v?p:e.b
t=A.aSV(w,u,f)
s=x?p:d.a
s=A.j(s,v?p:e.a,f)
r=x?p:d.c
r=A.aMz(r,v?p:e.c,f)
q=x?p:d.d
q=A.aMk(q,v?p:e.d,f)
x=x?p:d.e
x=A.bM(x,v?p:e.e,f)
x.toString
return new B.hT(s,t,r,q,x)},
hT:function hT(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
a3L:function a3L(d,e){var _=this
_.b=d
_.d=_.c=null
_.e=$
_.w=_.r=_.f=null
_.z=_.y=_.x=$
_.Q=null
_.a=e},
aHd:function aHd(){},
aHe:function aHe(d){this.a=d},
aHf:function aHf(d,e,f){this.a=d
this.b=e
this.c=f},
agM(d,e){return new B.wV(e,d,null)},
wV:function wV(d,e,f){this.w=d
this.b=e
this.a=f}},D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[12],B)
D=c[26]
B.hT.prototype={
Ft(d,e){return this.e.fs(d,e)},
gbv(){return this.e.glt()},
gDU(){return this.d!=null},
dI(d,e){var x
A:{if(d instanceof A.cy){x=B.asK(B.aUM(d),this,e)
break A}if(y.b.b(d)){x=B.asK(d,this,e)
break A}x=this.QS(d,e)
break A}return x},
dJ(d,e){var x
A:{if(d instanceof A.cy){x=B.asK(this,B.aUM(d),e)
break A}if(y.b.b(d)){x=B.asK(this,d,e)
break A}x=this.QT(d,e)
break A}return x},
i(d,e){var x=this
if(e==null)return!1
if(x===e)return!0
if(J.O(e)!==A.n(x))return!1
return e instanceof B.hT&&J.b(e.a,x.a)&&J.b(e.c,x.c)&&A.cF(e.d,x.d)&&e.e.i(0,x.e)},
gt(d){var x=this,w=x.d
w=w==null?null:A.bh(w)
return A.K(x.a,x.b,x.c,x.e,w,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)},
hM(d,e,f){return this.e.hM(new A.y(0,0,0+d.a,0+d.b),e,f)},
xb(d){d.toString
return new B.a3L(this,d)}}
B.a3L.prototype={
apz(d,e){var x,w,v,u=this
if(d.i(0,u.c)&&e==u.d)return
if(u.r==null)x=u.b.a!=null
else x=!1
if(x){$.Z()
x=A.b7()
u.r=x
w=u.b.a
if(w!=null)x.r=w.gp()}x=u.b
w=x.d
if(w!=null){if(u.w==null){u.w=w.length
v=A.Y(new A.a2(w,new B.aHd(),A.X(w).h("a2<1,p4>")),y.m)
u.z=v}if(x.e.giq()){w=A.Y(new A.a2(w,new B.aHe(d),A.X(w).h("a2<1,y>")),y.n)
u.x=w}else{w=A.Y(new A.a2(w,new B.aHf(u,d,e),A.X(w).h("a2<1,Fs>")),y.c)
u.y=w}}w=x.e
if(!w.giq())v=u.r!=null||u.w!=null
else v=!1
if(v)u.e=w.fs(d,e)
if(x.c!=null)u.f=w.jV(d,e)
u.c=d
u.d=e},
arK(d,e,f){var x,w,v,u,t=this
if(t.w!=null){x=t.b.e
if(x.giq()){w=0
for(;;){v=t.w
v.toString
if(!(w<v))break
v=t.x
v===$&&A.a()
v=v[w]
u=t.z
u===$&&A.a()
x.iS(d,v,u[w],f);++w}}else{w=0
for(;;){x=t.w
x.toString
if(!(w<x))break
x=t.y
x===$&&A.a()
x=x[w]
v=t.z
v===$&&A.a()
d.ic(x,v[w]);++w}}}},
arJ(d){var x,w=this.b,v=w.e
if(v instanceof A.cC&&w.a!=null){x=v.a
if(x.a.ge8()===255&&x.c===C.x)return d.cN(-(x.gdm()/2))}return d},
aoL(d,e){var x,w=this,v=w.b.c
if(v==null)return
x=w.Q
if(x==null){x=w.a
x.toString
x=w.Q=v.CL(x)
v=x}else v=x
x=w.c
x.toString
v.qn(d,x,w.f,e)},
l(){var x=this.Q
if(x!=null)x.l()
this.QP()},
jM(d,e,f){var x,w=this,v=f.e,u=e.a,t=e.b,s=new A.y(u,t,u+v.a,t+v.b),r=f.d
w.apz(s,r)
w.arK(d,s,r)
if(w.r!=null){v=w.b.e
if(v.giq()){x=w.arJ(s)
u=w.r
u.toString
v.iS(d,x,u,r)}else{v=w.e
v===$&&A.a()
u=w.r
u.toString
d.ic(v,u)}}w.aoL(d,f)
w.b.e.iR(d,s,r)}}
B.wV.prototype={
m0(d,e){return B.agM(e,this.w)},
cB(d){return!this.w.i(0,d.w)}}
var z=a.updateTypes([])
B.aHd.prototype={
$1(d){return d.iv()},
$S:619}
B.aHe.prototype={
$1(d){return this.a.cD(d.b).cN(d.d)},
$S:620}
B.aHf.prototype={
$1(d){return this.a.b.e.fs(this.b.cD(d.b).cN(d.d),this.c)},
$S:621};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.hT,A.hg)
x(B.a3L,A.mi)
w(A.fs,[B.aHd,B.aHe,B.aHf])
x(B.wV,A.c5)})()
A.m4(b.typeUniverse,JSON.parse('{"hT":{"hg":[]},"a3L":{"mi":[]},"wV":{"c5":[],"b_":[],"aH":[],"e":[]}}'))
var y={m:A.W("p4"),c:A.W("Fs"),n:A.W("y"),b:A.W("hT?")};(function constants(){D.oK=new A.dN(C.r,C.r,C.r,C.r)
D.a_9=new A.F(48,48)})()};
(a=>{a["flPg934Lka4rQb5V7zlsG4etlZ0="]=a.current})($__dart_deferred_initializers__);