import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { DefaultProps } from '@primitives/types/styled-system'

const H3 = styled.h3<DefaultProps>`
  ${styleSystemProps};
`

H3.displayName = 'Primitives.H3'

export default H3
