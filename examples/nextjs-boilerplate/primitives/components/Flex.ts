import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { StyledSystemDefaultProps } from '@primitives/types/styled-system'

const Box = styled.div<StyledSystemDefaultProps>`
  display: flex;
  ${styleSystemProps};
`

Box.displayName = 'Primitives.Box'

export default Box
