<?php $__env->startSection('title', 'Security'); ?>

<?php $__env->startSection('content'); ?>
<h5>Security Monitoring</h5>

<!-- Stats -->
<div class="row my-4">
  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>Cameras Online</h6><h4><?php echo e($stats['cameras_online']); ?></h4>
  </div></div></div>
  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>Active Incidents</h6><h4><?php echo e($stats['active_incidents']); ?></h4>
  </div></div></div>
  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>Recording</h6><h4><?php echo e($stats['recording']); ?></h4>
  </div></div></div>
  <div class="col-md-3"><div class="card text-center"><div class="card-body">
    <h6>System Status</h6><h4 class="<?php echo e($stats['system_status_class']); ?>"><?php echo e($stats['system_status']); ?></h4>
  </div></div></div>
</div>

<!-- Camera Feed -->
<div class="card mb-4">
  <div class="card-header">Main Entrance - Front Door <span class="badge bg-danger">REC</span></div>
  <div class="card-body text-center">
    <div class="bg-dark text-white p-5">[Live Camera Feed Placeholder]</div>
    <div class="mt-2">
      <button class="btn btn-secondary btn-sm">Play</button>
      <button class="btn btn-secondary btn-sm">Pause</button>
      <button class="btn btn-secondary btn-sm">Fullscreen</button>
    </div>
  </div>
</div>

<!-- Recent Incidents -->
<div class="row mt-4">
  <div class="col-md-12">
    <h6>Recent Incidents</h6>
    <ul class="list-group">
      <?php $__currentLoopData = $incidents; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $incident): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
        <li class="list-group-item">
          <?php echo e($incident['description']); ?> <br>
          <small>Location: <?php echo e($incident['location']); ?> | Date: <?php echo e($incident['date']); ?></small>
          <button class="btn btn-sm btn-danger float-end">Investigate</button>
        </li>
      <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
    </ul>
  </div>
</div>

<!-- Incident Types Chart -->
<div class="mt-4">
  <h6>Incident Types Overview</h6>
  <canvas id="incidentTypes"></canvas>
</div>

<script>
  new Chart(document.getElementById('incidentTypes'), {
    type: 'bar',
    data: {
      labels: <?php echo json_encode(array_column($incidentStats, 'type')); ?>,
      datasets: [{
        label: 'Incidents',
        data: <?php echo json_encode(array_column($incidentStats, 'count')); ?>,
        backgroundColor: 'red'
      }]
    }
  });
</script>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/security.blade.php ENDPATH**/ ?>