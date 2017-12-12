(function() {
  // load our current votes
  var votes = JSON.parse(document.getElementById('currentResults').textContent);

  var addTweet = function(tweet) {
    // load our outer container, template and generate a copy of the template
    var container = document.querySelector('.js-tweet-ticker'),
        template = container.querySelector('template'),
        clone = document.importNode(template.content, true);

    // update the inner content of the template
    clone.querySelector('[data-content=screen_name]').textContent = tweet.screen_name;
    clone.querySelector('[data-content=text]').textContent = tweet.text;

    // prepend the new tweet to the container
    container.insertBefore(clone, container.firstChild);
  };

  var updatePieChart = function(votes) {
    var radius = 25,
        circumference = 2 * Math.PI * radius,
        percentage = (votes.apple || 0) / ((votes.apple || 0) + (votes.android || 0)),
        value = circumference * percentage;

    console.log("votes:", votes);

    document.querySelector('.js-pie-slice').style.strokeDasharray = `${value.toFixed(2)} ${circumference.toFixed(2)}`;
  }

  var updateVoteCounts = function(votes) {
    var counters = document.querySelectorAll('.js-vote-count');
    counters.forEach(function(element) {
      element.textContent = votes[element.getAttribute('data-candidate')] || 0;
    });
  }

  // load our pusher key
  var pusherKey = document.querySelector('[data-pusher-key]').getAttribute('data-pusher-key');

  // create a Pusher configuration
  var pusher = new Pusher(pusherKey, {
    cluster: 'eu',
    encrypted: true
  });

  // connect to the `votes` channel
  var channel = pusher.subscribe('updates');

  // when we receive a tweet
  channel.bind('tweet', function handlePusherTweet(value) {
    console.log('Received tweet:', value);
    addTweet(value);
  });

  // when we receive the latest status
  channel.bind('vote', function handlePusherStatus(value) {
    console.log('Vote received:', value);
    votes[value.vote_for] = (votes[value.vote_for] || 0) + 1;
    updatePieChart(votes);
    updateVoteCounts(votes);
  });

  // on load re-render the pie chart
  updatePieChart(votes);
  updateVoteCounts(votes);

})();
