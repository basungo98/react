import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { DefaultProps } from '@primitives/types/styled-system'

const H6 = styled.h6<DefaultProps>`
  ${styleSystemProps};
`

H6.displayName = 'Primitives.H6'

export default H6
