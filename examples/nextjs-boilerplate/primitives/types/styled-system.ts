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

export type DefaultProps =
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

export type ImageProps = PositionProps | LayoutProps | SpaceProps
