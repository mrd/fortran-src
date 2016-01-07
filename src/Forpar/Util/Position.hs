{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DeriveGeneric #-}

module Forpar.Util.Position where

import Data.Data
import Data.Typeable
import Text.PrettyPrint.GenericPretty
import Text.PrettyPrint

import GHC.Generics

import Forpar.Util.FirstParameter
import Forpar.Util.SecondParameter

class Loc a where
  getPos :: a -> Position

data Position = Position 
  { posAbsoluteOffset   :: Integer
  , posColumn           :: Integer
  , posLine             :: Integer
  } deriving (Eq, Data, Typeable)

instance Show Position where
  show (Position _ c l) = (show l) ++ ":" ++ (show c)

initPosition :: Position
initPosition = Position 
  { posAbsoluteOffset = 0
  , posColumn = 1
  , posLine = 1 
  }

data SrcSpan = SrcSpan Position Position deriving (Eq, Typeable, Data, Generic)

instance Show SrcSpan where
  show (SrcSpan s1 s2)= "(" ++ (show s1) ++ "," ++ (show s2) ++ ")"

instance Out SrcSpan where
  doc s = text $ show s
  docPrec _ = doc

initSrcSpan :: SrcSpan
initSrcSpan = SrcSpan initPosition initPosition

class Spanned a where
  getSpan :: a -> SrcSpan
  setSpan :: SrcSpan -> a -> a

  default getSpan :: (SecondParameter a SrcSpan) => a -> SrcSpan
  getSpan a = getSecondParameter a

  default setSpan :: (SecondParameter a SrcSpan) => SrcSpan -> a -> a
  setSpan e a = setSecondParameter e a
