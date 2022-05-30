import express from 'express'
import cors from 'cors'
import morgan from 'morgan'
import helmet from 'helmet'
import config from './config'

import pkg from '../package.json'

import authRoutes from './routes/auth.routes'
import usersRoutes from './routes/users.routes'
// import formsRoutes from './routes/forms.routes'

const app = express()

// Settings
app.set('pkg', pkg)
app.set('port', config.port)
app.set('json spaces', 4)

// Middlewares
const corsOptions = {
    // origin: "http://localhost:3000",
}
app.use(cors(corsOptions))
app.use(helmet())
app.use(morgan('dev'))
app.use(express.json())
app.use(express.urlencoded({ extended: false }))

// Welcome Routes
app.get('/', (_, res) => {
    res.json({
        message: 'Welcome to my Products API',
        name: app.get('pkg').name,
        version: app.get('pkg').version,
        description: app.get('pkg').description,
        author: app.get('pkg').author,
    })
})

// Routes
app.use('/api/auth', authRoutes)
app.use('/api/users', usersRoutes)
// app.use('/api/forms', formsRoutes)

export default app
