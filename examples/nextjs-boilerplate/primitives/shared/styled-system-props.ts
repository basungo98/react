import { css } from 'styled-components'
import {
  background,
  border,
  color,
  compose,
  flexbox,
  grid,
  layout,
  position,
  shadow,
  space,
  typography,
} from 'styled-system'

export const styleSystemProps = css`
  ${compose(
    background,
    border,
    color,
    flexbox,
    grid,
    layout,
    position,
    shadow,
    space,
    typography,
  )}
`

export const imageStyleSystemProps = css`
  ${compose(layout, position, space)}
`
