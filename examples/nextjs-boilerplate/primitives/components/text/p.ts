import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { StyledSystemDefaultProps } from '@primitives/types/styled-system'

const P = styled.p<StyledSystemDefaultProps>`
  ${styleSystemProps};
`

P.displayName = 'Primitives.P'

export default P
