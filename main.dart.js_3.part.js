((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,A,C,B={
aS2(d){var x,w,v
switch(d.w.a){case 1:x=d.c
w=x!=null?new A.dV(0,x.gmO()):C.kx
break
case 0:x=d.d
w=d.c
if(x!=null){v=w==null?null:w.gmO()
w=new A.dc(x,v==null?C.t:v)}else if(w==null)w=D.op
break
default:w=null}return new B.hQ(d.a,d.f,d.b,d.e,w)},
aqU(d,e,f){var x,w,v,u,t,s,r,q,p=null
if(d==e)return d
x=d==null
if(!x&&e!=null){if(f===0)return d
if(f===1)return e}w=x?p:d.b
v=e==null
u=v?p:e.b
t=A.aQb(w,u,f)
s=x?p:d.a
s=A.M(s,v?p:e.a,f)
r=x?p:d.c
r=A.aK0(r,v?p:e.c,f)
q=x?p:d.d
q=A.aJM(q,v?p:e.d,f)
x=x?p:d.e
x=A.dL(x,v?p:e.e,f)
x.toString
return new B.hQ(s,t,r,q,x)},
hQ:function hQ(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
a2j:function a2j(d,e){var _=this
_.b=d
_.d=_.c=null
_.e=$
_.w=_.r=_.f=null
_.z=_.y=_.x=$
_.Q=null
_.a=e},
aES:function aES(){},
aET:function aET(d){this.a=d},
aEU:function aEU(d,e,f){this.a=d
this.b=e
this.c=f},
af5(d,e){return new B.wj(e,d,null)},
wj:function wj(d,e,f){this.w=d
this.b=e
this.a=f}},D
J=c[1]
A=c[0]
C=c[2]
B=a.updateHolder(c[15],B)
D=c[30]
B.hQ.prototype={
Fd(d,e){return this.e.h5(d,e)},
gbJ(){return this.e.glg()},
gDB(){return this.d!=null},
dA(d,e){var x
A:{if(d instanceof A.ct){x=B.aqU(B.aS2(d),this,e)
break A}if(y.b.b(d)){x=B.aqU(d,this,e)
break A}x=this.Q3(d,e)
break A}return x},
dB(d,e){var x
A:{if(d instanceof A.ct){x=B.aqU(this,B.aS2(d),e)
break A}if(y.b.b(d)){x=B.aqU(this,d,e)
break A}x=this.Q4(d,e)
break A}return x},
i(d,e){var x=this
if(e==null)return!1
if(x===e)return!0
if(J.O(e)!==A.l(x))return!1
return e instanceof B.hQ&&J.b(e.a,x.a)&&J.b(e.c,x.c)&&A.cz(e.d,x.d)&&e.e.i(0,x.e)},
gt(d){var x=this,w=x.d
w=w==null?null:A.bn(w)
return A.J(x.a,x.b,x.c,x.e,w,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)},
hE(d,e,f){return this.e.hE(new A.x(0,0,0+d.a,0+d.b),e,f)},
wT(d){d.toString
return new B.a2j(this,d)}}
B.a2j.prototype={
aoy(d,e){var x,w,v,u=this
if(d.i(0,u.c)&&e==u.d)return
if(u.r==null)x=u.b.a!=null
else x=!1
if(x){$.a_()
x=A.b5()
u.r=x
w=u.b.a
if(w!=null)x.r=w.gp()}x=u.b
w=x.d
if(w!=null){if(u.w==null){u.w=w.length
v=A.Y(new A.a0(w,new B.aES(),A.X(w).h("a0<1,S2>")),y.m)
u.z=v}if(x.e.gib()){w=A.Y(new A.a0(w,new B.aET(d),A.X(w).h("a0<1,x>")),y.n)
u.x=w}else{w=A.Y(new A.a0(w,new B.aEU(u,d,e),A.X(w).h("a0<1,Eb>")),y.c)
u.y=w}}w=x.e
if(!w.gib())v=u.r!=null||u.w!=null
else v=!1
if(v)u.e=w.h5(d,e)
if(x.c!=null)u.f=w.jH(d,e)
u.c=d
u.d=e},
aqs(d,e,f){var x,w,v,u,t=this
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
x.iH(d,v,u[w],f);++w}}else{w=0
for(;;){x=t.w
x.toString
if(!(w<x))break
x=t.y
x===$&&A.a()
x=x[w]
v=t.z
v===$&&A.a()
d.i1(x,v[w]);++w}}}},
aqr(d){var x,w=this.b,v=w.e
if(v instanceof A.cN&&w.a!=null){x=v.a
if(x.a.geA()===255&&x.c===C.D)return d.cE(-(x.gdi()/2))}return d},
anK(d,e){var x,w=this,v=w.b.c
if(v==null)return
x=w.Q
if(x==null){x=w.a
x.toString
x=w.Q=v.Cs(x)
v=x}else v=x
x=w.c
x.toString
v.qc(d,x,w.f,e)},
l(){var x=this.Q
if(x!=null)x.l()
this.Q0()},
jx(d,e,f){var x,w=this,v=f.e,u=e.a,t=e.b,s=new A.x(u,t,u+v.a,t+v.b),r=f.d
w.aoy(s,r)
w.aqs(d,s,r)
if(w.r!=null){v=w.b.e
if(v.gib()){x=w.aqr(s)
u=w.r
u.toString
v.iH(d,x,u,r)}else{v=w.e
v===$&&A.a()
u=w.r
u.toString
d.i1(v,u)}}w.anK(d,f)
w.b.e.jy(d,s,r)}}
B.wj.prototype={
oo(d,e){return B.af5(e,this.w)},
cI(d){return!this.w.i(0,d.w)}}
var z=a.updateTypes([])
B.aES.prototype={
$1(d){return d.ii()},
$S:609}
B.aET.prototype={
$1(d){return this.a.cu(d.b).cE(d.d)},
$S:610}
B.aEU.prototype={
$1(d){return this.a.b.e.h5(this.b.cu(d.b).cE(d.d),this.c)},
$S:611};(function inheritance(){var x=a.inherit,w=a.inheritMany
x(B.hQ,A.h9)
x(B.a2j,A.lX)
w(A.ep,[B.aES,B.aET,B.aEU])
x(B.wj,A.ch)})()
A.iN(b.typeUniverse,JSON.parse('{"hQ":{"h9":[]},"a2j":{"lX":[]},"wj":{"ch":[],"aZ":[],"aK":[],"e":[]}}'))
var y={m:A.V("S2"),c:A.V("Eb"),n:A.V("x"),b:A.V("hQ?")};(function constants(){D.op=new A.dC(C.t,C.t,C.t,C.t)
D.ZF=new A.D(48,48)})()};
(a=>{a["TjRNtnoCpzHGmtYsPNHmjr4W+18="]=a.current})($__dart_deferred_initializers__);