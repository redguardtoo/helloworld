      program xif
      implicit none
      real :: x
      real, parameter :: x1 = 0.3, x2 = 0.6
      call random_seed()
      call random_number(x)
      if (x < x1) then
         print*,x,"<",x1
      else if (x < x2) then
         print*,x,"<",x2
      else
         print*,x,">=",x2
      end if
      end program xif

      FUNCTION func_name(a, b)
      INTEGER :: func_name
      INTEGER :: a
      REAL    :: b
      return
      func_name = (2*a)+b
      RETURN
      END FUNCTION
      
      PROGRAM cows
      IMPLICIT NONE
      INTEGER :: func_name
      PRINT *,func_name(2, 1.3)
      END PROGRAM

      subroutine square_cube(i,isquare,icube)
      integer, intent(in)  :: i ! input
      integer, intent(out) :: isquare,icube ! output
      isquare = i**2
      icube   = i**3
      end subroutine square_cube

      program xx
      implicit none
      integer :: i,isq,icub
      i = 4
      call square_cube(i,isq,icub)
      print*,"i,i^2,i^3=",i,isq,icub
      end program xx

      INTEGER          :: x
      IF (x < 50) THEN
         Grade = 'F'
      ELSE IF (x < 60) THEN
         Grade = 'D'
      ELSE IF (x < 70) THEN
         Grade = 'C'
      ELSE IF (x < 80) THEN
         Grade = 'B'
      ELSE
         Grade = 'A'
      END IF

      SELECT CASE (selector)
      CASE (label-list-1)
         statements-1
      CASE (label-list-2)
         statements-2
      CASE (label-list-3)
         statements-3
     .        ............
      CASE (label-list-n)
         statements-n
      CASE DEFAULT
         statements-DEFAULT
      END SELECT

      do i=1,10
      print*,i**2
      end do

      while (logical expr) do
         statements
      enddo

      do
         statements
      until (logical expr)

      FORALL (I = 1:N, J = 1:N)
      WHERE(A(I, J) .NE. 0.0) B(I, J) = 1.0/A(I, J)
      END FORALL

      ENUM :: COLORS
      ENUMERATOR :: PURPLE
      ENUMERATOR :: RED = 2, BLUE = 5
      ENUMERATOR GREEN
      END ENUM

      INTERFACE
         FUNCTION Area_Circle (r)
         REAL, Area_Circle
         REAL, INTENT(IN) :: r
         END FUNCTION Area_Circle
      END INTERFACE

      module mymod
      implicit none
      private
      public :: myfunc
      contains
      function myfunc(x) result(y)
      implicit none
      integer, intent(in)  :: x
      integer              :: y
      ...
      end function myfunc
      end module mymod