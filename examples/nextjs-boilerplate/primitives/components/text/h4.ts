import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { DefaultProps } from '@primitives/types/styled-system'

const H4 = styled.h4<DefaultProps>`
  ${styleSystemProps};
`

H4.displayName = 'Primitives.H4'

export default H4
