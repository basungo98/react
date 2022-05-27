import { Router } from 'express'
import { getProtectionAreasById } from '../controllers/forms.controller'

const router = Router()

router.get('/protectionareas/:id', getProtectionAreasById)

export default router
