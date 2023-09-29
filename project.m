G = cartGrid([100,50,1]);
plotGrid(G,'FaceColor','none','EdgeAlpha',0.5)
axis equal
axis tight off
% view(3)
G = computeGeometry(G);

%rock properties 
rock = makeRock(G,100*milli*darcy,0.25);
faultLength = 20;
ind = sub2ind([100,50],repmat(50,1,faultLength),1:faultLength);
rock.perm(ind) = eps;
plotCellData(G,rock.perm,'EdgeAlpha',0.2)
colormap('bone')
colorbar
hT = computeTrans(G,rock);


%fluid properties 

mrstModule add incomp
fluid = initSimpleFluid('mu',[1,10],'rho',[1000 1000],'n',[2 2]);
T = 10*year;
rate = sum(poreVolume(G,rock))/T;


%well model
W = addWell([],G, rock, 1, 'Type', 'rate', 'Val', rate, 'Name', 'Injector', 'Radius', 0.1, 'Comp_i', [1 0]);
W = addWell(W,G, rock, G.cells.num, 'Type', 'rate', 'Val', -rate, 'Name', 'Producer', 'Radius', 0.1, 'Comp_i', [0 1]);

% Plot wells

plotWell(G,W)
view(3)
state = initState(G,W,100*barsa, [0 1]);
tsn = 300;
tsv = T/tsn;
time = 0;

for i = 1:tsn

 state = incompTPFA(state, G, hT, fluid, 'Wells', W);
 state = implicitTransport(state, G, tsv, rock, fluid, 'Wells', W);
 x = G.cells.centroids(:,1);
 y = G.cells.centroids(:,2);
 X = reshape(x, G.cartDims);
 Y = reshape(y, G.cartDims);
 Z = reshape(state.s(:,1),G.cartDims);

 contourf(X,Y,Z,20, 'EdgeColor','none');
 plotGrid(G,ind,'FaceColor','k')
 caxis([0 1])
 axis equal
 axis([0 100 0 50])
 set(gca,'XTick',[],'YTick',[])
 colormap(flipud(jet))
 colorbar
 time = time + T/tsn;
 title(sprintf('Injection Duration = %.2f years',convertTo(time,year)))
pause(0.01)

end

