import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { StyledSystemDefaultProps } from '@primitives/types/styled-system'

const H1 = styled.h1<StyledSystemDefaultProps>`
  ${styleSystemProps};
`

H1.displayName = 'Primitives.H1'

export default H1
