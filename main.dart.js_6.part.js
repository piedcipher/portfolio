((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var B,C,A={
aLP(d,e){return new B.nh(A.b5L(d),C.G,!0,null,e,null)},
b5L(d){var y,x
if(d===0)return B.e0()
y=Math.sin(d)
if(y===1)return A.atA(1,0)
if(y===-1)return A.atA(-1,0)
x=Math.cos(d)
if(x===-1)return A.atA(0,-1)
return A.atA(y,x)},
atA(d,e){var y=new Float64Array(16)
y[0]=e
y[1]=d
y[4]=-d
y[5]=e
y[10]=1
y[15]=1
return new B.bG(y)}}
B=c[0]
C=c[2]
A=a.updateHolder(c[14],A)
var z=a.updateTypes([])};
(a=>{a["fz0XCBMEyW1y7RzcO9UK4WPan8E="]=a.current})($__dart_deferred_initializers__);