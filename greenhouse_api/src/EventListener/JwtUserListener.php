<?php

namespace App\EventListener;

use App\Entity\User;
use Lexik\Bundle\JWTAuthenticationBundle\Event\AuthenticationSuccessEvent;

class JwtUserListener
{
    public function onAuthenticationSuccess(AuthenticationSuccessEvent $event): void
    {
        $data = $event->getData();
        $user = $event->getUser();

        if (!$user instanceof User) {
            return;
        }

        $payload = $data;
        $payload['id'] = $user->getId();
        $payload['firstname'] = $user->getFirstName();
        $payload['lastname'] = $user->getLastName();
        $payload['email'] = $user->getEmail();

        $event->setData($payload);
    }

    public function onAuthentification(AuthenticationSuccessEvent $event): void
    {
        $this->onAuthenticationSuccess($event);
    }
}
