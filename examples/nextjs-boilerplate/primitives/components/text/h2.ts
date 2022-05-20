import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { StyledSystemDefaultProps } from '@primitives/types/styled-system'

const H2 = styled.h2<StyledSystemDefaultProps>`
  ${styleSystemProps};
`

H2.displayName = 'Primitives.H2'

export default H2
