import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { DefaultProps } from '@primitives/types/styled-system'

const H1 = styled.h1<DefaultProps>`
  ${styleSystemProps};
`

H1.displayName = 'Primitives.H1'

export default H1
