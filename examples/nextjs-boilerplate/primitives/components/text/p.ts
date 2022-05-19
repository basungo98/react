import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { DefaultProps } from '@primitives/types/styled-system'

const P = styled.p<DefaultProps>`
  ${styleSystemProps};
`

P.displayName = 'Primitives.P'

export default P
