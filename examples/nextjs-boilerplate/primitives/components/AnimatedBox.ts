import { animated } from 'react-spring'
import styled from 'styled-components'
import { styleSystemProps } from '@primitives/shared/styled-system-props'
import { StyledSystemDefaultProps } from '@primitives/types/styled-system'

const AnimatedBox = styled(animated.div)<StyledSystemDefaultProps>`
  ${styleSystemProps};
`

AnimatedBox.displayName = 'Primitives.AnimatedBox'

export default AnimatedBox
