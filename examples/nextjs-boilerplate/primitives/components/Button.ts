import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { StyledSystemDefaultProps } from '@primitives/types/styled-system'
import styled, { css } from 'styled-components'

const buttonReset = css`
  background-color: transparent;
  padding: 0;
  margin: 0;
  color: inherit;
  border: none;
  font: inherit;
  line-height: normal;
  overflow: visible;
  -webkit-font-smoothing: inherit;
  -moz-osx-font-smoothing: inherit;
  -webkit-appearance: none;
`

const Button = styled.button<StyledSystemDefaultProps>`
  ${buttonReset};
  ${styleSystemProps};
`

Button.displayName = 'Primitives.Button'

export default Button
