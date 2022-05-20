import {
  BackgroundProps,
  BorderProps,
  ColorProps,
  FlexboxProps,
  GridProps,
  LayoutProps,
  PositionProps,
  ShadowProps,
  SpaceProps,
  TypographyProps,
} from 'styled-system'

type HTMLDivAttributesProps = React.HTMLAttributes<HTMLElement> & {
  ref: any
}

export type StyledSystemDefaultProps =
  | BackgroundProps
  | BorderProps
  | ColorProps
  | FlexboxProps
  | GridProps
  | LayoutProps
  | PositionProps
  | ShadowProps
  | SpaceProps
  | TypographyProps
  | HTMLDivAttributesProps

export type ImageProps =
  | PositionProps
  | LayoutProps
  | SpaceProps
  | HTMLDivAttributesProps
