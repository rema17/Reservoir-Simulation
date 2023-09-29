[nx, ny, nz] = deal(30,30,10);
G = cartGrid([nx, ny, nz]);
G = computeGeometry(G);

%define rock properties SI unite

rock = makeRock(G,200*milli*darcy,0.25);
hT = computeTrans(G,rock);


%define fluid properties 

mrstModule add incomp
fluid = initSingleFluid('mu',1*centi*poise,'rho',1000);


%define well location

W = verticalWell([], G, rock, 1, 1, 1:nz, 'Type', 'rate', 'Val', 1000*meter^3/day, 'Radius', 0.1, 'Name', 'Injector', 'Comp_i', 1);
W = verticalWell(W , G, rock, nx, ny, 1:nz, 'Type', 'bhp', 'Val', 800*psia, 'Radius', 0.1, 'Name', 'Producer', 'Comp_i', 1);

gravity on 

state  = initState(G, W, 3000*psia);
state  = incompTPFA(state, G, hT, fluid, 'Wells', W);

plotCellData(G,convertTo(state.pressure,psia))
plotCellData(G, convertTo(state.pressure, psia));
plotWell(G, W(1), 'Height', 2, 'Color', 'b') 
plotWell(G, W(2), 'Height', 2, 'Color', 'k') 
view(3)
axis tight off
colormap('Jet')




