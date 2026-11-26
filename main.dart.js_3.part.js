((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aSq(d){var x,w,v
switch(d.w.a){case 1:x=d.c
w=x!=null?new A.dY(0,x.gmQ()):C.kE
break
case 0:x=d.d
w=d.c
if(x!=null){v=w==null?null:w.gmQ()
w=new A.de(x,v==null?C.t:v)}else if(w==null)w=D.os
break
default:w=null}return new B.hT(d.a,d.f,d.b,d.e,w)},
arh(d,e,f){var x,w,v,u,t,s,r,q,p=null
if(d==e)return d
x=d==null
if(!x&&e!=null){if(f===0)return d
if(f===1)return e}w=x?p:d.b
v=e==null
u=v?p:e.b
t=A.aQA(w,u,f)
s=x?p:d.a
s=A.M(s,v?p:e.a,f)
r=x?p:d.c
r=A.aKj(r,v?p:e.c,f)
q=x?p:d.d
q=A.aK7(q,v?p:e.d,f)
x=x?p:d.e
x=A.dN(x,v?p:e.e,f)
x.toString
return new B.hT(s,t,r,q,x)},
hT:function hT(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
a2t:function a2t(d,e){var _=this
_.b=d
_.d=_.c=null
_.e=$
_.w=_.r=_.f=null
_.z=_.y=_.x=$
_.Q=null
_.a=e},
aFf:function aFf(){},
aFg:function aFg(d){this.a=d},
aFh:function aFh(d,e,f){this.a=d
this.b=e
this.c=f},
afp(d,e){return new B.wr(e,d,null)},
wr:function wr(d,e,f){this.w=d
this.b=e
this.a=f}},D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[15],B)
D=c[30]
B.hT.prototype={
Fw(d,e){return this.e.h6(d,e)},
gbJ(){return this.e.glf()},
gDP(){return this.d!=null},
dA(d,e){var x
A:{if(d instanceof A.ct){x=B.arh(B.aSq(d),this,e)
break A}if(y.b.b(d)){x=B.arh(d,this,e)
break A}x=this.Qg(d,e)
break A}return x},
dB(d,e){var x
A:{if(d instanceof A.ct){x=B.arh(this,B.aSq(d),e)
break A}if(y.b.b(d)){x=B.arh(this,d,e)
break A}x=this.Qh(d,e)
break A}return x},
i(d,e){var x=this
if(e==null)return!1
if(x===e)return!0
if(J.O(e)!==A.m(x))return!1
return e instanceof B.hT&&J.b(e.a,x.a)&&J.b(e.c,x.c)&&A.cA(e.d,x.d)&&e.e.i(0,x.e)},
gt(d){var x=this,w=x.d
w=w==null?null:A.bl(w)
return A.J(x.a,x.b,x.c,x.e,w,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)},
hD(d,e,f){return this.e.hD(new A.x(0,0,0+d.a,0+d.b),e,f)},
wR(d){d.toString
return new B.a2t(this,d)}}
B.a2t.prototype={
aoZ(d,e){var x,w,v,u=this
if(d.i(0,u.c)&&e==u.d)return
if(u.r==null)x=u.b.a!=null
else x=!1
if(x){x=A.aZ()
u.r=x
w=u.b.a
if(w!=null)x.r=w.gp()}x=u.b
w=x.d
if(w!=null){if(u.w==null){u.w=w.length
v=A.Y(new A.a_(w,new B.aFf(),A.X(w).h("a_<1,Sc>")),y.m)
u.z=v}if(x.e.gib()){w=A.Y(new A.a_(w,new B.aFg(d),A.X(w).h("a_<1,x>")),y.n)
u.x=w}else{w=A.Y(new A.a_(w,new B.aFh(u,d,e),A.X(w).h("a_<1,Ek>")),y.c)
u.y=w}}w=x.e
if(!w.gib())v=u.r!=null||u.w!=null
else v=!1
if(v)u.e=w.h6(d,e)
if(x.c!=null)u.f=w.jH(d,e)
u.c=d
u.d=e},
aqX(d,e,f){var x,w,v,u,t=this
if(t.w!=null){x=t.b.e
if(x.gib()){w=0
for(;;){v=t.w
v.toString
if(!(w<v))break
v=t.x
v===$&&A.a()
v=v[w]
u=t.z
u===$&&A.a()
x.iK(d,v,u[w],f);++w}}else{w=0
for(;;){x=t.w
x.toString
if(!(w<x))break
x=t.y
x===$&&A.a()
x=x[w]
v=t.z
v===$&&A.a()
d.fU(x,v[w]);++w}}}},
aqW(d){var x,w=this.b,v=w.e
if(v instanceof A.cN&&w.a!=null){x=v.a
if(x.a.geA()===255&&x.c===C.C)return d.cF(-(x.gdj()/2))}return d},
ao8(d,e){var x,w=this,v=w.b.c
if(v==null)return
x=w.Q
if(x==null){x=w.a
x.toString
x=w.Q=v.CF(x)
v=x}else v=x
x=w.c
x.toString
v.qe(d,x,w.f,e)},
l(){var x=this.Q
if(x!=null)x.l()
this.Qd()},
jx(d,e,f){var x,w=this,v=f.e,u=e.a,t=e.b,s=new A.x(u,t,u+v.a,t+v.b),r=f.d
w.aoZ(s,r)
w.aqX(d,s,r)
if(w.r!=null){v=w.b.e
if(v.gib()){x=w.aqW(s)
u=w.r
u.toString
v.iK(d,x,u,r)}else{v=w.e
v===$&&A.a()
u=w.r
u.toString
d.fU(v,u)}}w.ao8(d,f)
w.b.e.jy(d,s,r)}}
B.wr.prototype={
oq(d,e){return B.afp(e,this.w)},
cI(d){return!this.w.i(0,d.w)}}
var z=a.updateTypes([])
B.aFf.prototype={
$1(d){return d.ii()},
$S:611}
B.aFg.prototype={
$1(d){return this.a.cv(d.b).cF(d.d)},
$S:612}
B.aFh.prototype={
$1(d){return this.a.b.e.h6(this.b.cv(d.b).cF(d.d),this.c)},
$S:613};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.hT,A.hd)
x(B.a2t,A.m0)
w(A.ep,[B.aFf,B.aFg,B.aFh])
x(B.wr,A.ch)})()
A.iR(b.typeUniverse,JSON.parse('{"hT":{"hd":[]},"a2t":{"m0":[]},"wr":{"ch":[],"aY":[],"aJ":[],"e":[]}}'))
var y={m:A.U("Sc"),c:A.U("Ek"),n:A.U("x"),b:A.U("hT?")};(function constants(){D.os=new A.dD(C.t,C.t,C.t,C.t)
D.ZI=new A.D(48,48)})()};
(a=>{a["IsdOBH3vVnYgQMGl+9a5OQiYV5U="]=a.current})($__dart_deferred_initializers__);