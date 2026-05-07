<?php $__env->startSection('title', 'Notifications'); ?>

<?php $__env->startSection('content'); ?>
<h5>Notifications</h5>

<?php if(session('success')): ?>
  <div class="alert alert-success"><?php echo e(session('success')); ?></div>
<?php endif; ?>

<div class="row mt-4">
  <div class="col-md-12">
    <ul class="list-group">
      <?php $__empty_1 = true; $__currentLoopData = $notifications; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $notif): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
        <li class="list-group-item d-flex justify-content-between align-items-center">
          <div>
            <strong><?php echo e($notif['title']); ?></strong><br>
            <small class="text-muted"><?php echo e($notif['message']); ?></small>
          </div>
          <span class="badge 
            <?php if($notif['type'] === 'urgent'): ?> bg-danger
            <?php elseif($notif['type'] === 'warning'): ?> bg-warning
            <?php else: ?> bg-info
            <?php endif; ?>">
            <?php echo e(strtoupper($notif['type'])); ?>

          </span>
        </li>
      <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
        <li class="list-group-item text-muted">Aucune notification disponible</li>
      <?php endif; ?>
    </ul>

    <!-- Bouton pour effacer les notifications -->
    <form action="<?php echo e(route('notifications.clear')); ?>" method="POST" class="mt-3">
      <?php echo csrf_field(); ?>
      <button type="submit" class="btn btn-outline-danger">Effacer les notifications</button>
    </form>
  </div>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\modif\projet_soutenance_l3\backend\resources\views/notifications.blade.php ENDPATH**/ ?>