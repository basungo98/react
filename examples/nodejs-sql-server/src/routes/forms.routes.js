import { Router } from 'express'
import { getProtectionAreasById } from '../controllers/forms.controller'
import { authJwt } from '../middlewares'

const router = Router()

router.get(
  '/protectionareas/:id',
  [authJwt.verifyToken],
  getProtectionAreasById,
)

export default router
