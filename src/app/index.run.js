(function() {
  'use strict';

  angular
    .module('pub')
    .run(runBlock);

  /** @ngInject */
  function runBlock($log) {

    $log.debug('runBlock end');
  }

})();
