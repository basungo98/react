import { animated } from 'react-spring'
import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { DefaultProps } from '@primitives/types/styled-system'

const AnimatedBox = styled(animated.div)<DefaultProps>`
  ${styleSystemProps};
`

AnimatedBox.displayName = 'Primitives.AnimatedBox'

export default AnimatedBox
