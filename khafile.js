let project = new Project('Grafikha');

project.localLibraryPath = 'libs'
project.addLibrary("dconsole");

project.addSources('Sources');
project.addAssets('Assets/**');

resolve(project);
