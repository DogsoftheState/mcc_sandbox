#define OX 0
#define OY 1
#define OZ 2
private["_x", "_y", "_z", "_a", "_t_sin", "_t_cos", "_dir", "_up"];
_a  = _this select 1;	
_t_sin = sin -(_a select OX);
_t_cos = cos -(_a select OX);
_x = [[_t_cos,_t_sin,0],[-_t_sin,_t_cos,0],[0,0,1]];
_t_sin = sin (_a select OY);
_t_cos = cos (_a select OY);
_y = [[1,0,0],[0,_t_cos,_t_sin],[0,-_t_sin,_t_cos]];
_t_sin = sin (_a select OZ);
_t_cos = cos (_a select OZ);
_z = [[_t_cos,0,-_t_sin],[0,1,0],[_t_sin,0,_t_cos]];
#define M1(X,Y) ((_x select X) select Y)
#define M2(X,Y) ((_y select X) select Y)
#define ROL [[M2(0,0) * M1(0,0) + M2(0,1) * M1(1,0) + M2(0,2)*M1(2,0),M2(0,0) * M1(0,1) + M2(0,1) * M1(1,1) + M2(0,2)*M1(2,1),M2(0,0) * M1(0,2) + M2(0,1) * M1(1,2) + M2(0,2)*M1(2,2)],[M2(1,0) * M1(0,0) + M2(1,1) * M1(1,0) + M2(1,2)*M1(2,0),M2(1,0) * M1(0,1) + M2(1,1) * M1(1,1) + M2(1,2)* M1(2,1),M2(1,0) * M1(0,2) + M2(1,1) * M1(1,2) + M2(1,2)* M1(2,2)],[M2(2,0) * M1(0,0) + M2(2,1) * M1(1,0) + M2(2,2)*M1(2,0),M2(2,0) * M1(0,1) + M2(2,1) * M1(1,1) + M2(2,2)*M1(2,1),M2(2,0) * M1(0,2) + M2(2,1) * M1(1,2) + M2(2,2)*M1(2,2)]]
_a = ROL;
#undef M1
#undef M2
#define M1(X,Y) ((_a select X) select Y)
#define M2(X,Y) ((_z select X) select Y)
_a= ROL;
#undef ROL
#define ROL [M1(1,0) * VY + M1(2,0) * VZ,M1(1,1) * VY + M1(2,1) * VZ,M1(1,2) * VY + M1(2,2) * VZ]
#define VY 1
#define VZ 0
_dir = ROL;
#undef VY
#undef VZ
#define VY 0
#define VZ 1
_up = ROL;
(_this select 0) setvectordir _dir;
(_this select 0) setvectorup _up;
[_up,_dir]