%% Rough dump for all testings with the plots

h(1) = subplot(3,3,1:3);
h(2) = subplot(3,3,6:9);

ax = gca
ax.XGrid = 'on'
ax.YGrid = 'on'
ax.YMinorGrid = 'on'
ax.XMinorGrid = 'on'
ax.YGrid = 'off'
ax.YGrid = 'on'

ax.MinorGridColor = [0 0 0]
ax.MinorGridColor = [255 255 255]
ax.MinorGridColor = [1 1 1 ]
ax.MinorGridColor = [255 255 255]
ax.MinorGridColor = [0 0 0]

plot(ax, ax.UserData)

set(ax, 'UserData', [1:100])
drawnow

ax = [subplot(2,2,1:2) subplot(2,2,3:4)];
h(1) = plot(ax(1), 1,2,'b*');
h(2) = plot(ax(2), 2,2,'r*');
hold(ax(1),'on');
hold(ax(2),'on');


%% Testing the intersection with the wall part
xlimit = [0 gridSize];
ylimit = [0  gridSize];
xbox = xlimit([1 1 2 2 1]);
ybox = ylimit([1 2 2 1 1]);
mapshow(xbox,ybox,'DisplayType','polygon','LineStyle','none')

visibility = 25;
pos = [50 50];
dirVec = 1/sqrt(2)*[1 1];
pos1 = pos + dirVec * visibility;            % dot(pos, dirVec); 
% Define and display a two-part polyline
m = tand(dirVec(2)/dirVec(1));
x = [pos(1) pos1(1)];
y = [pos(2) pos1(2)];
mapshow(x,y,'Marker','+')

% Intersect the polyline with the rectangle
[xi, yi] = polyxpoly(x, y, xbox, ybox);
mapshow(xi,yi,'DisplayType','point','Marker','o')













