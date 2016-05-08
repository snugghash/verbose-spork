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
