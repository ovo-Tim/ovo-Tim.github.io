#import "/typ/templates/blog.typ": *
#import "@preview/calloutly:1.2.0": (
  callout, callout-style, calloutly, caution, code-block-style, error, important, note, success, tip, warning,
)
#show: main.with(
  title: "A quick intro to Geometric Deep Learning(WIP)",
  desc: [This article aims to answer what Geometric Deep Learning is, how it works and why it is useful by providing you a quick walk-through to derive convolution from shift-equivariance.],
  date: "2026-09-20",
  tags: (
    blog-tags.dl,
    blog-tags.math,
  ),
)
Coauthored with #link("https://github.com/Zikai311")[Zikai Wang].

Most of the time we consider deep learning as an engineering problem -- we are told what works what doesn't, what
standard solution is to a specific problem.
But very few people ask why. Geometric Deep Learning provides us with the mathematical tools to understand why all those famous architectures, including CNN, LSTM, Transformer etc. work better than plain MLP.

To further explain how it works and why it is useful, we will skip all the math in the front part of #link("https://geometricdeeplearning.com/book/")[Original _Geometric Deep Learning_ book] and give you a quick walk-through to derive convolution(core of CNN) from shift-equivariance.

#tip[
  = Before you start
  Here are some nice youtube videos can give some sense of Group Theory. It's not required to understand this article, but it definitely helps.
  - #link("https://www.youtube.com/watch?v=tGCqP2ytP14")[_Group Theory Step-by-Step: 1 - 7_] by TheGrayCuber
  - #link("https://www.youtube.com/watch?v=KufsL2VgELo")[_What is Group Theory? — Group Theory Ep. 1_] by Nemean

  No need to remember all the details, feel it.
  // TODO: understand how CNN works(what is feature map, what is kernel)
]

= Shift Equivariance
Let's start with a 1D example with 4 pixels.
$
  bold(x) = vec(x_0, x_1, x_2, x_3)
$
You can imagine, each value of x is the brightness of a pixel.

Since we want to discuss shift equivariance, we need to first define what is a shift operation. To make things simple at first, we will assume images with no boundary, which means positions wrap around in a circle. We call this property *periodic boundary condition*. For example, if we shift the image by 1 pixel to the right, the new image shall be:
$
  vec(x_0, x_1, x_2, x_3) arrow vec(x_3, x_0, x_1, x_2)
$
Let's call this shift operation $S$. Naturally we got $S vec(x_0, x_1, x_2, x_3) = vec(x_3, x_0, x_1, x_2)$.

And the $u$'s component of the shifted image is
$
  (S_a x)_u = x_((u - a) mod n)
$

#note[
  If you were familiar with group theory, you should notice we just formed a group $G={I, S, S^2, S^3}$.
  But I want to make some obvious things clear for those who have zero background in group theory.

  - An operation can be composed multiple times, and we denote that as $S^n$, $n$ is the number of times we apply the operation.
    $
      S^2 vec(x_0, x_1, x_2, x_3) = vec(x_2, x_3, x_0, x_1)
    $
  - Also an operation can be composed.
  // TODO
]

Now suppose we have an image-processing layer $F$ that takes an image as input and outputs a feature map with the same size as the input.
$
  F(vec(x_0, x_1, x_2, x_3)) = vec(y_0, y_1, y_2, y_3)
$
Then the shift equivariance is simply $F(S(x)) = S(F(x))$, meaning *the shift in the input will result in the same shift in the output*.

// TODO
// #callout(title: "Extra example")[

// ]

Sometimes we call properties like this *Inductive Bias*, which is a prior assumption built into a learning algorithm about what kinds of functions are likely to solve the task.
For example, in the model's perspective, Shift invariance means that if the cat in the image moved a few pixels, the output feature map should move the same distance. By embedding those rules into loss function(e.g. by adding regularization) or architecture, we can make the model work more efficiently.
We will see exactly how that works in the next chapter.

= Deriving Convolution with Matrix Representation
On a discrete grid *with periodic boundary conditions*, the unit shift $S_1$ corresponds to a simple permutation matrix:
$
  S_1 = mat(
    delim: "[",
    0, 0, dots, 0, 1;
    1, 0, dots, 0, 0;
    0, 1, dots, 0, 0;
    dots.v, dots.v, dots.down, dots.v, dots.v;
    0, 0, dots, 1, 0;
  )
$

Suppose we want our layer $F(x) = W x$, where $W in bb(R)^(n times n)$ is the weight matrix to be determined.

Using elementary linear algebra, let us examine the restrictions that this commutativity constraint $W S_1 = S_1 W$ imposes on the entries $W_(u, v)$ of matrix $W$. Right-multiplication by the shift operator $(W S_1)_(u, v)$ shifts column $v + 1$ of $W$ to column $v$, which yields
$ (W S_1)_(u, v) = W_(u, (v + 1) mod n) $.

Whereas the left-multiplication by the shift operator, $(S_1 W)_(u, v)$shifts row $u - 1$ of $W$ to row $u$, which yields
$
  (S_1 W)_(u, v) = W_((u - 1) mod n, v)
$
From $W S_1 = S_1 W$, we obtain the fundamental constraint equation:
$ W_(u, v+1 mod n) = W_((u - 1) mod n, v) quad forall u, v $
letting $u'=u-1$,
$ W_((u'+1) mod n, (v + 1) mod n) = W_(u', v) quad forall u', v $

This relations reveals that a shift equivariant matrix must have the same value along its main diagonal and entries parallel to it (with periodic boundary conditions).
Setting $k = (u - v) mod n$, this demonstrates that the entry $W_(u, v)$ depends solely on the index difference $(u - v)$. If we define an $n$-dimensional parameter vector $theta_k := W_(k, 0)$, then

$ W_(u, v) = theta_((u - v) mod n) $

Substituting this back into $W$, its structure is necessarily

$
  W = C(theta) = mat(
    delim: "[",
    theta_0, theta_(n-1), theta_(n-2), dots, theta_1;
    theta_1, theta_0, theta_(n-1), dots, theta_2;
    theta_2, theta_1, theta_0, dots, theta_3;
    dots.v, dots.v, dots.v, dots.down, dots.v;
    theta_(n-1), theta_(n-2), theta_(n-3), dots, theta_0;
  )
$


Now, consider the $u$-th component of the feature map $y = W x = C(theta) x$:

$ y_u = sum_(v=0)^(n-1) W_(u, v) x_v = sum_(v=0)^(n-1) theta_((u - v) mod n) x_v = (x * theta)_u $

This is precisely the definition of discrete convolution. In other words, the mathematical framework naturally deduces the convolution formula from linearity and shift equivariance

= Another Perspective: Impulse Function Representation
// TODO: polish this after learning more
In the example above, representing an image as a vector works perfectly well. However, this is not the most general way to represent a signal. For more complex domains, such as spheres or graphs, a vector representation can obscure the underlying structure of the domain. In GDL, a more general and natural approach is to represent a signal as a *function*, sometimes also called a *mapping*.

The standard form of this kind of representation is:
$
  x: Omega -> R
$
where $Omega$ is the domain of the signal. So what it does is, you give it a "position" in the domain and it returns the value of the signal at that position. For example, suppose we have an image with 4 pixels:
$
  mat(
    delim: "[",
    a, b;
    c, d
  )
$
In our previous vector representation, it's flattened as
$
  x = vec(a, b, c, d)
$
However, in the function representation, we can define the domain as $Omega = {(0, 0), (0, 1), (1, 0), (1, 1)}$ and the function as
$
  x((0, 0)) = a, x((0, 1)) = b, x((1, 0)) = c, x((1, 1)) = d
$

So that the geometry is preserved in the domain $Omega$, while $x$ merely assigns data to points of $Omega$.
== Representing an Image Using Function.
Again, to keep things simple, we are going to represent a 1D image as the linear combination of impulse functions. But what's even an impulse function?

We all know that every vector can be reconstructed from its coordinates and the standard basis vectors:
$
  vec(a, b, c)=a vec(1, 0, 0) + b vec(0, 1, 0) + c vec(0, 0, 1)
$

When we are presenting an image as a function, we also want an analogous set of “basis functions”, which picks out each position of the domain.
This is exactly what the *impulse function* does:
$
  delta_0(u) = cases(
    1\, u = 0,
    0\, u!= 0
  ) space, u in Z
$
By itself, it means one bright pixel at the origin...
```
... 0 0 1 0 0...
        ^
        0
```
..., which is not very useful. But we can combine it with the shift operation we defined earlier to represent any image. To make things easier to read, we define $delta_v = S^v (delta_0)$. Then any signal $x$ can be assembled out of these one-pixel signals:
$
  x(u) = sum_(v in Z) a(v) delta_v (u)
$
For simplicity's sake $x$ is also written as $x = sum_(v in Z) a(v) delta_v$. Keep in mind that $delta_v$ is a function.

For example, an image like this:
```
position:      -1   0   1
x:              2   5  -1
```
can be represented as $x = 2 delta_(-1) + 5 delta_0 -1 delta_1$.

== From Shift Equivariance to Convolution
Let's also start from a linear layer $F$, which takes a signal $x: Z -> R$ and outputs a signal $y: Z -> R$.(So when you see $[F(x)](u)$ below, it means the u-th component of the output signal $y$.) For now, Shift Equivariance and Linearity are all we need to derive the convolution operation.

Plug in the representation of $x$ above to our layer $F$, we have:
$
  [F(x)](u) = F(sum_(v in Z) a(v) delta_v (u))
$
Because $F$ is linear, we can move it inside the summation:
$
  [F(x)](u) = sum_(v in Z) a(v) [F(delta_v)](u)
  = sum_(v in Z) a(v) F(S^v delta_0)(u)
$
Because $F$ is shift equivariant, we can replace $F(delta_v)$ with $S^v F(delta_0)$.
$
  [F(x)](u) = sum_(v in Z) a(v) [S^v F(delta_0)](u)
$

The key insight shift equivariant told us here, is that now the output of $F$ is independent to exact signal $S_v$.
Instead, $F(delta_0)$ is a constant "vector" to all the input signals. When we process different positions, we simply shift this "constant vector". We call it a *kernel* in convolution term. Let's denote $theta = F(delta_0)$ ($theta: Z -> R$), then
$
  [F(x)](u) = sum_(v in Z) a(v) S^v theta(u)
$

According to the definition of the shift operation, $(S^v g)(u) = g(u - v)$. We now get:
$
  [F(x)](u) = sum_(v in Z) a(v) theta(u - v)
$
which is exactly the definition of discrete convolution.

