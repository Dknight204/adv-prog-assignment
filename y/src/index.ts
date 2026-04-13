import { Hono } from 'hono'
interface User  {
 id: number;
  name: string;
  email: string;
  password: string | number;
}
const users: User[] = [{ id: 1, name: "nigus", email: "nsolomon@.com", password: "123" },
];

const app = new Hono();
app.get('/', (c) => {
  return c.text('Hello nigus !')
})
app.get('/users/:id', (c) => {
  const id = Number( c.req.param('id'));
  const user = users.find((u) => u.id === (id));
 if (!user) {
    return c.json({ error: "User not found" }, 404);}
  return c.json({
     'your Id is': id, 'and your name is': user.name
   })

})
  app.post('/signup', async (c) => {
  try {
    const body = await c.req.json();

    if (users.some(u => u.email === body.email)) {
      return c.json({ error: "Email already exists" }, 400);
    }
  const newUser: User = {
    id:users.length > 0 ? users[users.length - 1].id + 1 : 1,
    name: body.name,
    email: body.email,
    password: body.password
  };

  users.push(newUser);
  return c.json(newUser, 201); 
  
}catch (e) {
    return c.json({ error: "Invalid JSON body" }, 400);}
  })
app.post('/signin', async (c) => {
  try {
    const body = await c.req.json();

    const user = users.find(u => u.email === body.email && u.password === body.password);

    if (!user) {
      return c.json({ error: "Invalid email or password" }, 401);
    }

    return c.json({
      message: "Login successful!",
      user: {
        id: user.id,
        name: user.name,
        email: user.email
      }
    });
  } catch (e) {
    return c.json({ error: "Invalid JSON body" }, 400);
  }
})

app.get('/users', (c) => c.json(users))

app.get('/users/:id', (c) => {
  const id = Number(c.req.param('id'));
  const user = users.find(u => u.id === id);
  return user ? c.json(user) : c.json({ error: "Not found" }, 404);
})
export default app